class Igraph < Formula
  desc "Network analysis package"
  homepage "http://igraph.org"
  url "http://igraph.org/nightly/get/c/igraph-0.7.1.tar.gz"
  sha256 "d978030e27369bf698f3816ab70aa9141e9baf81c56cc4f55efbe5489b46b0df"
  revision 3

  bottle do
    cellar :any
    sha256 "d5aa04fb769a88612b34f290a3023136150dc4a8ec4e6f379f716505ea254cb6" => :el_capitan
    sha256 "149b2be62efcee21ff30db00796d2742758ba21cccb3f0d0b834e1635b961061" => :yosemite
    sha256 "1ce6615a2d2cbbc2fd509caa8ecc805755c81a70a237b4c485ba75da9b7997e0" => :mavericks
    sha256 "a34161eba244911b357d823be94dee50f3e594c09e92c5d2bade26590a1e8e09" => :x86_64_linux
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
