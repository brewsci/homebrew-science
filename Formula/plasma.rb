class Plasma < Formula
  desc "Parallel Linear Algebra for Multicore Architectures"
  homepage "http://icl.cs.utk.edu/plasma"
  url "http://icl.cs.utk.edu/projectsfiles/plasma/pubs/plasma_2.8.0.tar.gz"
  sha256 "b2f2226c275c6a26ba15f040816cc25b6849134a65563e04d38b9144070230d3"
  revision 2

  bottle do
    cellar :any
    sha256 "ba79d2e61f0fcac5c4858f7ef7482852b94d89e15530e66e26adc2c1186acb2c" => :sierra
    sha256 "d375cf0b0598d1fea460f0e8a8f914944d5635133d6daa8deb02df6479e14249" => :el_capitan
    sha256 "378183fd6da4a44635e0ffb5a964d1cccd8ecf193cf8123f18d16d836d36a175" => :yosemite
  end

  depends_on "hwloc"
  depends_on :fortran

  resource "lapacke" do
    # LAPACKE is now included in the main LAPACK distribution.
    url "http://www.netlib.org/lapack/lapack-3.6.0.tgz"
    sha256 "a9a0082c918fe14e377bbd570057616768dca76cbdc713457d8199aaa233ffc3"
  end

  # fixes "gfortran: error: auxiliary.o: No such file or directory"
  patch :DATA

  def install
    resource("lapacke").stage do
      cp "make.inc.example", "make.inc"
      make_args = [
        "CC=#{ENV.cc}",
        "FORTRAN=#{ENV["FC"]}",
        "LOADER=#{ENV["FC"]}",
        "RANLIB=true",
      ]
      cd "LAPACKE" do
        system "make", "lapacke", *make_args
      end
      system "make", "tmglib", *make_args
      include.install Dir["LAPACKE/include/*.h"]
      lib.install "liblapacke.a", "libtmglib.a"
    end

    make_args = [
      "prefix=#{prefix}",
      "CC=#{ENV.cc}",
      "FC=#{ENV["FC"]}",
      "RANLIB=true",
      "FFLAGS=#{ENV["FFLAGS"]}",
      "LIBBLAS=-lblas",
      "LIBLAPACK=-llapack",
      "LIBCBLAS=-lcblas",
      "INCCLAPACK=-I#{include}",
      "LIBCLAPACK=-L#{lib} -llapacke -ltmglib",
      "PLASMA_F90=1",
    ]

    cp "makes/make.inc.mac", "make.inc"
    system "make", *make_args
    system "make", "test"
    system "make", "example"
    lib.install Dir["lib/*"], "quark/libquark.a"
    include.install Dir["include/*"], Dir["quark/*.h"]
    doc.install Dir["docs/pdf/*"]
    pkgshare.install Dir["examples/*.c"], Dir["examples/*.f"], Dir["examples/*.f90"], Dir["examples/*.d"]
    pkgshare.install "timing"
  end

  def caveats; <<-EOS.undent
    PLASMA should not be used in conjunction with a multithreaded BLAS to avoid
    creating more threads than actual cores. Please set

      export VECLIB_MAXIMUM_THREADS=1

    when using PLASMA.
    EOS
  end

  test do
    ENV.fortran
    ENV["VECLIB_MAXIMUM_THREADS"] = "1"
    cp pkgshare/"example_dposv_f.f", testpath
    libs = [
      "-L#{opt_lib}", "-lplasma", "-lcoreblasqw", "-lcoreblas", "-lquark",
      "-L#{Formula["hwloc"].opt_lib}", "-lhwloc",
      "-lblas", "-llapack", "-llapacke"
    ]
    system ENV["FC"], "example_dposv_f.f", "-I#{opt_include}", "-o", "example_dposv_f", *libs
    system "./example_dposv_f"
  end
end

__END__
diff --git a/timing/Makefile b/timing/Makefile
index fabd207..889c0f6 100644
--- a/timing/Makefile
+++ b/timing/Makefile
@@ -87,13 +87,13 @@ time_%.o : time_%.c $(ALLHDR)
 %auxiliary.o : %auxiliary.c $(ALLHDR)
	$(CC) $(CFLAGS) -c $< -o $@

-time_s% : time_s%.o sauxiliary.o
+time_s% : time_s%.o sauxiliary.o auxiliary.o
	$(LOADER) $@.o auxiliary.o sauxiliary.o -o $@ $(LDFLAGS)
-time_d% : time_d%.o dauxiliary.o
+time_d% : time_d%.o dauxiliary.o auxiliary.o
	$(LOADER) $@.o auxiliary.o dauxiliary.o -o $@ $(LDFLAGS)
-time_c% : time_c%.o cauxiliary.o
+time_c% : time_c%.o cauxiliary.o auxiliary.o
	$(LOADER) $@.o auxiliary.o cauxiliary.o -o $@ $(LDFLAGS)
-time_z% : time_z%.o zauxiliary.o
+time_z% : time_z%.o zauxiliary.o auxiliary.o
	$(LOADER) $@.o auxiliary.o zauxiliary.o -o $@ $(LDFLAGS)

 time_zlapack2tile time_clapack2tile time_dlapack2tile time_slapack2tile : auxiliary.o
