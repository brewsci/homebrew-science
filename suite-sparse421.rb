class SuiteSparse421 < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "http://faculty.cse.tamu.edu/davis/suitesparse.html"
  url "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-4.2.1.tar.gz"
  mirror "http://pkgs.fedoraproject.org/repo/pkgs/suitesparse/SuiteSparse-4.2.1.tar.gz/4628df9eeae10ae5f0c486f1ac982fce/SuiteSparse-4.2.1.tar.gz"
  sha256 "e8023850bc30742e20a3623fabda02421cb5774b980e3e7c9c6d9e7e864946bd"
  revision 1

  bottle do
    cellar :any
    sha256 "5d2ae0ae1c9c34d61ab513d40fef24d2741a88eb58dd77b5d02eb9008b3a1844" => :yosemite
    sha256 "9fae6dac5f6d01333e4218e25412f62c9eaa71c337181fb147c96b0cacdef457" => :mavericks
    sha256 "0b1b7d6aafffc1103c59d7d78479a6f2dfb786b9da056167b769a58629f9427e" => :mountain_lion
  end

  option "with-matlab", "Install Matlab interfaces and tools"
  option "with-matlab-path=", "Path to Matlab executable (default: matlab)"

  depends_on "tbb" => :recommended
  depends_on "openblas" => :optional
  depends_on "metis4" => :optional # metis 5.x is not yet supported by suite-sparse

  depends_on :fortran if build.with? "matlab"

  keg_only "Conflicts with suite-sparse"

  def install
    # SuiteSparse doesn't like to build in parallel
    ENV.deparallelize

    # Switch to the Mac base config, per SuiteSparse README.txt
    mv "SuiteSparse_config/SuiteSparse_config.mk",
       "SuiteSparse_config/SuiteSparse_config_orig.mk"
    mv "SuiteSparse_config/SuiteSparse_config_Mac.mk",
       "SuiteSparse_config/SuiteSparse_config.mk"

    cflags = "#{ENV.cflags}"
    cflags += " -I#{Formula["tbb"].opt_include}" if build.with? "tbb"

    make_args = ["CFLAGS=#{cflags}",
                 "INSTALL_LIB=#{lib}",
                 "INSTALL_INCLUDE=#{include}"
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
      EOS
    end
    s
  end
end
