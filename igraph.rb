class Igraph < Formula
  desc "Network analysis package"
  homepage "http://igraph.org"
  url "http://igraph.org/nightly/get/c/igraph-0.7.1.tar.gz"
  sha256 "d978030e27369bf698f3816ab70aa9141e9baf81c56cc4f55efbe5489b46b0df"
  revision 3

  bottle do
    cellar :any
    sha256 "10af6313ad683101ac38119d1befb1ed904aba6dde18fa0b2ebb95c879404275" => :el_capitan
    sha256 "8b5042a5833912ed35152d01ee3ea58bf14dc7bef217491a8a18c0fe52370227" => :yosemite
    sha256 "4596ad187c5446798794ea3e2ad213d0758898c7c9c4b579342fbf338370ea7f" => :mavericks
  end

  option :universal

  # Use Homebrew Arpack, but disable thread-local storage.
  # If not selected, iGraph uses a built-in Arpack.
  depends_on "arpack" => :optional

  # GMP is optional, and doesn't have a universal build
  depends_on "gmp" => :optional unless build.universal?

  depends_on "glpk" => :recommended

  def install
    ENV.universal_binary if build.universal?

    # There doesn't seem to be a way to specify which BLAS/LAPACK, ARPACK or GPLK.
    # iGraph just looks for -lblas, -llapack, -larpack and -lglpk on the path.
    extra_opts = ["--with-external-blas", "--with-external-lapack"]
    extra_opts << ((build.with? "glpk") ? "--with-external-glpk" : "--disable-glpk")
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
