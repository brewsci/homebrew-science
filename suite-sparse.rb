class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "http://faculty.cse.tamu.edu/davis/suitesparse.html"
  url "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-4.5.3.tar.gz"
  sha256 "6199a3a35fbce82b155fd2349cf81d2b7cddaf0dac218c08cb172f9bc143f37a"

  bottle do
    cellar :any
    sha256 "bc5683521cbb2065c5460a9f91331680a8a4d17e1358518f2117d001d56d0b15" => :sierra
    sha256 "a53bbf4ebd0636ac08095c16be433a84f615179ae6d7cf6b48112e2d4d6aa3f1" => :el_capitan
    sha256 "1e333295fed780557ba4feecf3e0788b0bdeaed651ad02b4d81ac704c1a0f5cd" => :yosemite
    sha256 "5d532fc7fdef8479aea2f53ebc3d321e40649e323a27612ff41d0a9f9a357e06" => :mavericks
    sha256 "cc1dd40cee45d0d984d2c6edbc79ba76caa2a864f5089537feea51ac63a2b022" => :x86_64_linux
  end

  option "with-matlab", "Install Matlab interfaces and tools"
  option "with-matlab-path=", "Path to Matlab executable (default: matlab)"
  option "with-openmp", "Build with OpenMP support"

  option "without-test", "Do not perform build-time tests (not recommended)"

  depends_on "tbb" => :recommended
  depends_on "openblas" => (OS.mac? ? :optional : :recommended)

  # SuiteSparse must be compiled with metis 5 and ships with metis-5.1.0.
  # We prefer to use Homebrew metis.
  depends_on "metis"

  depends_on :fortran if build.with? "matlab"
  needs :openmp if build.with? "openmp"

  # libtbb isn't linked in.
  patch :DATA

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

    # SuiteSparse ships with metis5 but we use the Homebrew version
    make_args += ["MY_METIS_LIB=-L#{Formula["metis"].opt_lib} -lmetis",
                  "MY_METIS_INC=#{Formula["metis"].opt_include}"]

    # Only building libraries
    system "make", "library", *make_args
    system "make", "install", "INSTALL=#{prefix}", *make_args

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
    end

    # Install static libs.
    %w[AMD BTF CAMD CCOLAMD CHOLMOD COLAMD CSparse CXSparse KLU LDL RBio SPQR UMFPACK].each do |m|
      lib.install Dir["#{m}/Lib/*.a"]
    end
    lib.install "SuiteSparse_config/libsuitesparseconfig.a"

    # Install demos
    %w[AMD CAMD CCOLAMD CHOLMOD COLAMD CXSparse KLU LDL SPQR UMFPACK].each do |m|
      (pkgshare/"demo/#{m}").install Dir["#{m}/Demo/*"]
    end
    (pkgshare/"demo/CXSparse").install "CXSparse/Matrix"
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

__END__
diff --git a/SPQR/Lib/Makefile b/SPQR/Lib/Makefile
index eaade58..d0de852 100644
--- a/SPQR/Lib/Makefile
+++ b/SPQR/Lib/Makefile
@@ -13,7 +13,7 @@ ccode: all
 include ../../SuiteSparse_config/SuiteSparse_config.mk

 # SPQR depends on CHOLMOD, AMD, COLAMD, LAPACK, the BLAS and SuiteSparse_config
-LDLIBS += -lamd -lcolamd -lcholmod -lsuitesparseconfig $(LAPACK) $(BLAS)
+LDLIBS += -lamd -lcolamd -lcholmod -lsuitesparseconfig $(TBB) $(LAPACK) $(BLAS)

 # compile and install in SuiteSparse/lib
 library:
