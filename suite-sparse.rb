class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "http://faculty.cse.tamu.edu/davis/suitesparse.html"
  url "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-4.5.1.tar.gz"
  sha256 "ac4524b9f69c4f8c2652d720b146c92a414c1943f86d46df49b4ff8377ae8752"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ab3b2ecad9e5c871a0b3e0e70f3bab4e7ee3aab06eb9ace8de2be155dfb11e8" => :el_capitan
    sha256 "ac375ecab7b93e9da612b14dcdd4fa920248dce10794f9131d8d2774967fefdd" => :yosemite
    sha256 "828dbaf089f5e98c31a9434748ab3d913aa018d473797b2b3e2d3c90ea52b0fb" => :mavericks
  end

  option "with-matlab", "Install Matlab interfaces and tools"
  option "with-matlab-path=", "Path to Matlab executable (default: matlab)"
  option "with-openmp", "Build with OpenMP support"

  option "without-test", "Do not perform build-time tests (not recommended)"

  depends_on "tbb" => :recommended
  depends_on "openblas" => :optional

  # SuiteSparse must be compiled with metis 5 and ships with metis-5.1.0.
  # We prefer to use Homebrew metis.
  depends_on "metis"

  depends_on :fortran if build.with? "matlab"
  needs :openmp if build.with? "openmp"

  def install
    cflags = [ENV.cflags.to_s]
    cflags << "-fopenmp" if build.with? "openmp"
    cflags << "-I#{Formula["tbb"].opt_include}" if build.with? "tbb"

    make_args = ["CFLAGS=#{cflags.join " "}"]

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

    # SuiteSparse is shipped with metis-5.1.0 but it can use Homebrew's version by
    # setting MY_METIS_LIB and MY_METIS_INC variables.
    make_args += ["MY_METIS_LIB=-L#{Formula["metis"].opt_lib} -lmetis",
                  "MY_METIS_INC=#{Formula["metis"].opt_include}"]

    # Only building libraries
    system "make", "library", *make_args

    if build.with? "matlab"
      matlab = ARGV.value("with-matlab-path") || "matlab"
      system matlab,
             "-nojvm", "-nodisplay", "-nosplash",
             "-r", "run('SuiteSparse_install(false)'); exit;"

      # Install Matlab scripts and Mex files.
      %w[AMD BTF CAMD CCOLAMD CHOLMOD COLAMD CSparse CXSparse KLU LDL SPQR UMFPACK].each do |m|
        (pkgshare/"matlab/#{m}").install Dir["#{m}/MATLAB/*"]
      end

      (pkgshare/"matlab").install "MATLAB_Tools"
      (pkgshare/"matlab").install "RBio/RBio"
      (doc/"matlab").install Dir["MATLAB_Tools/Factorize/Doc/*"]
    end

    prefix.install "include"
    so = OS.mac? ? "dylib" : "so"
    lib.install Dir["lib/*.#{so}"]

    # Install docs and demos
    %w[AMD CAMD CCOLAMD CHOLMOD COLAMD CXSparse KLU LDL SPQR UMFPACK].each do |m|
      (pkgshare/"demo/#{m}").install Dir["#{m}/Demo/*"]
    end
    (pkgshare/"demo/CXSparse").install "CXSparse/Matrix"
    doc.install Dir["share/doc/suitesparse-*/*"]
  end

  def caveats
    s = ""
    if build.with? "matlab"
      s += <<-EOS.undent
        Matlab interfaces and tools have been installed to

          #{pkgshare}/matlab
      EOS
    end
    s
  end

  test do
    cd testpath do
      system ENV["CC"], "-o", "amd_demo", "-O",
             pkgshare/"demo/AMD/amd_demo.c", "-L#{lib}", "-I#{include}",
             "-lsuitesparseconfig", "-lamd"
      system "./amd_demo"
      system ENV["CC"], "-o", "camd_demo", "-O",
             pkgshare/"demo/CAMD/camd_demo.c", "-L#{lib}", "-I#{include}",
             "-lsuitesparseconfig", "-lcamd"
      system "./camd_demo"
      system ENV["CC"], "-o", "ccolamd_example", "-O",
             pkgshare/"demo/CCOLAMD/ccolamd_example.c", "-L#{lib}", "-I#{include}",
             "-lsuitesparseconfig", "-lccolamd"
      system "./ccolamd_example"
      system ENV["CC"], "-o", "cholmod_simple", "-O",
             pkgshare/"demo/CHOLMOD/cholmod_simple.c", "-L#{lib}", "-I#{include}",
             "-lsuitesparseconfig", "-lcholmod"
      system "./cholmod_simple < #{pkgshare}/demo/CHOLMOD/Matrix/bcsstk01.tri"
      system ENV["CC"], "-o", "colamd_example", "-O",
             pkgshare/"demo/COLAMD/colamd_example.c", "-L#{lib}", "-I#{include}",
             "-lsuitesparseconfig", "-lcolamd"
      system "./colamd_example"
      system ENV["CC"], "-o", "cs_demo1", "-O",
             pkgshare/"demo/CXSparse/cs_demo1.c", "-L#{lib}", "-I#{include}",
             "-lsuitesparseconfig", "-lcxsparse"
      system "./cs_demo1 < #{pkgshare}/demo/CXSparse/Matrix/t1"
      system ENV["CC"], "-o", "klu_simple", "-O",
             pkgshare/"demo/KLU/klu_simple.c", "-L#{lib}", "-I#{include}",
             "-lsuitesparseconfig", "-lklu"
      system "./klu_simple"
      system ENV["CC"], "-o", "umfpack_simple", "-O",
             pkgshare/"demo/UMFPACK/umfpack_simple.c", "-L#{lib}", "-I#{include}",
             "-lsuitesparseconfig", "-lumfpack"
      system "./umfpack_simple"
    end
  end
end
