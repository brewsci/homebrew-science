class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "http://faculty.cse.tamu.edu/davis/suitesparse.html"
  url "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-4.4.4.tar.gz"
  sha256 "f2ae47e96f3f37b313c3dfafca59f13e6dbc1e9e54b35af591551919810fb6fd"
  revision 1

  bottle do
    cellar :any
    sha256 "dd83e718e3e9ff1e9d1b6c106a0ec1739de91007c242cf98cca999e161372e8d" => :yosemite
    sha256 "66ca698e1198daec5ab591c646030b49ff6a90714f70b86799c909cb7b4f5c9d" => :mavericks
    sha256 "523047f522181f05158db6e764afffe4bb6069d113bd914db0fafb327e0eee90" => :mountain_lion
  end

  option "with-matlab", "Install Matlab interfaces and tools"
  option "with-matlab-path=", "Path to Matlab executable (default: matlab)"

  depends_on "tbb" => :recommended
  depends_on "openblas" => :optional
  depends_on "metis4" => :optional # metis 5.x is not yet supported by suite-sparse

  depends_on :fortran if build.with? "matlab"

  def install
    # SuiteSparse doesn't like to build in parallel
    ENV.deparallelize

    # Switch to the Mac base config, per SuiteSparse README.txt
    mv "SuiteSparse_config/SuiteSparse_config.mk",
       "SuiteSparse_config/SuiteSparse_config_orig.mk"
    mv "SuiteSparse_config/SuiteSparse_config_Mac.mk",
       "SuiteSparse_config/SuiteSparse_config.mk"

    cflags = "#{ENV.cflags}"
    cflags += (ENV.compiler == :clang) ? "" : " -fopenmp"
    cflags += " -I#{Formula["tbb"].opt_include}" if build.with? "tbb"

    make_args = ["CFLAGS=#{cflags}",
                 "INSTALL_LIB=#{lib}",
                 "INSTALL_INCLUDE=#{include}",
                 "RANLIB=echo"
                ]
    if build.with? "openblas"
      make_args << "BLAS=-L#{Formula["openblas"].opt_lib} -lopenblas"
    elsif OS.mac?
      make_args << "BLAS=-framework Accelerate"
    else
      make_args << "BLAS=-lblas -llapack"
    end

    make_args << "LAPACK=$(BLAS)"
    make_args += ["SPQR_CONFIG=-DHAVE_TBB",
                  "TBB=-L#{Formula["tbb"].opt_lib} -ltbb"] if build.with? "tbb"
    make_args += ["METIS_PATH=",
                  "METIS=-L#{Formula["metis4"].opt_lib} -lmetis"] if build.with? "metis4"

    # Add some flags for linux
    # -DNTIMER is needed to avoid undefined reference to SuiteSparse_time
    make_args << "CF=-fPIC -O3 -fno-common -fexceptions -DNTIMER $(CFLAGS)" unless OS.mac?

    system "make", "default", *make_args # Also build demos.
    lib.mkpath
    include.mkpath
    system "make", "install", *make_args
    ["AMD", "CAMD", "CHOLMOD", "KLU", "LDL", "SPQR", "UMFPACK"].each do |pkg|
      (doc/pkg).install Dir["#{pkg}/Doc/*"]
    end

    if build.with? "matlab"
      matlab = ARGV.value("with-matlab-path") || "matlab"
      system matlab,
             "-nodesktop", "-nosplash",
             "-r", "run('SuiteSparse_install(false)'); exit;"

      # Install Matlab scripts and Mex files.
      %w[AMD BTF CAMD CCOLAMD CHOLMOD COLAMD CSparse CXSparse KLU LDL SPQR UMFPACK].each do |m|
        (share / "suite-sparse/matlab/#{m}").install Dir["#{m}/MATLAB/*"]
      end

      mdest = share / "suite-sparse/matlab"
      mdest.install "MATLAB_Tools"
      mdest.install "RBio/RBio"
      (doc/"matlab").install Dir["MATLAB_Tools/Factorize/Doc/*"]
    end
  end

  def caveats
    s = ""
    if build.with? "matlab"
      s += <<-EOS.undent
        Matlab interfaces and tools have been installed to

          #{share}/suite-sparse/matlab

        It is possible that the SPQR interface fail to compile
        if you use the defaults mexopts.sh or if your mexopts.sh
        does not use gcc-4.9.
      EOS
    end
    s
  end
end
