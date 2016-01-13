class Plasma < Formula
  desc "Parallel Linear Algebra for Multicore Architectures"
  homepage "http://icl.cs.utk.edu/plasma"
  url "http://icl.cs.utk.edu/projectsfiles/plasma/pubs/plasma_2.8.0.tar.gz"
  sha256 "e8758a71ddd02ad1fb57373cfd62fb1b32cebea62ba517484f1adf9f0afb1ddb"

  bottle do
    cellar :any
    sha256 "7b204b1f80e95c466924bd2f1f3dafea3afbf041c844cf22196405f5eb8272d0" => :el_capitan
    sha256 "4d209daaa8ebbd622381e48665f3e63dd1909fb737b02c77c09fd9416e28524d" => :yosemite
    sha256 "2dbb4bafd1ab74730ad81e44e2493d201b683396c5e3695bf443578e28b8bf48" => :mavericks
  end

  depends_on "hwloc"
  depends_on :fortran

  resource "lapacke" do
    # LAPACKE is now included in the main LAPACK distribution.
    url "http://www.netlib.org/lapack/lapack-3.6.0.tgz"
    sha256 "a9a0082c918fe14e377bbd570057616768dca76cbdc713457d8199aaa233ffc3"
  end

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
