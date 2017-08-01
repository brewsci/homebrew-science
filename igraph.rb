class Igraph < Formula
  desc "Network analysis package"
  homepage "http://igraph.org"
  url "http://igraph.org/nightly/get/c/igraph-0.7.1.tar.gz"
  sha256 "d978030e27369bf698f3816ab70aa9141e9baf81c56cc4f55efbe5489b46b0df"
  revision 5

  bottle do
    cellar :any
    sha256 "6ab53843c695c62fa33f86ef2424ca5f0e79d4de6e75c78a5c1aaec1565bd013" => :sierra
    sha256 "9945a529e34d92bea23c8603859e3a7ba10bd6305300cb2197e421cee18a5823" => :el_capitan
    sha256 "604729b5626349d80c46ae353b1ee3f5dd84b814f0d30445a374a547893787e6" => :yosemite
    sha256 "842de3d70d53be209201fe75b9cd1a8126fb5459164b27738f0ad07a3141e854" => :x86_64_linux
  end

  depends_on "libxml2" unless OS.mac?
  depends_on "openblas" unless OS.mac?

  # Use Homebrew Arpack, but disable thread-local storage.
  # If not selected, iGraph uses a built-in Arpack.
  depends_on "arpack" => :optional

  # GMP is optional
  depends_on "gmp" => :optional

  depends_on "glpk" => :recommended

  def install
    # There doesn't seem to be a way to specify which BLAS/LAPACK, ARPACK or GPLK.
    # iGraph just looks for -lblas, -llapack, -larpack and -lglpk on the path.
    extra_opts = ["--with-external-blas", "--with-external-lapack"]
    extra_opts << (build.with?("glpk") ? "--with-external-glpk" : "--disable-glpk")
    extra_opts << "--disable-gmp" if build.without? "gmp"
    extra_opts += ["--with-external-arpack", "--disable-tls"] if build.with? "arpack"

    # Make llvm happy. Check if still needed when Xcode > 7.3 is released.
    # Prevents "ld: section __DATA/__thread_bss extends beyond end of file"
    # See upstream LLVM issue https://llvm.org/bugs/show_bug.cgi?id=27059
    # igraph has decided to lower BN_MAXSIZE to 128 as a workaround:
    # https://github.com/igraph/igraph/issues/938
    # https://github.com/igraph/igraph/commit/0387a58419552aa69be2ac6aaa2f77ad8d6e9add
    # https://github.com/igraph/igraph/commit/01a547188b651c318d6a058079ad51c2908b5782
    inreplace "src/bignum.h", "BN_MAXSIZE 512", "BN_MAXSIZE 128"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          *extra_opts
    system "make", "install"
  end

  test do
    # Adapted from http://igraph.org/c/doc/igraph-tutorial.html
    (testpath / "igraph_test.c").write <<-EOS.undent
      #include <igraph.h>

      int main(void)
      {
          igraph_integer_t diameter;
          igraph_t graph;
          return 0;
      }
      EOS
    system ENV.cc, "igraph_test.c", "-I#{include}/igraph", "-L#{lib}",
                   "-ligraph", "-o", "igraph_test"
    system "./igraph_test"
  end
end
