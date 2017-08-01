class Igraph < Formula
  desc "Network analysis package"
  homepage "http://igraph.org"
  url "http://igraph.org/nightly/get/c/igraph-0.7.1.tar.gz"
  sha256 "d978030e27369bf698f3816ab70aa9141e9baf81c56cc4f55efbe5489b46b0df"
  revision 5

  bottle do
    cellar :any
    sha256 "8066f24f6d43ea475731ab5ae16e818b6a378da224e114134f045355d8c59eb9" => :sierra
    sha256 "52eb6bf980de24b98fba6c2d7435ccde5a166a549db2356e99e3d82b2123a5c4" => :el_capitan
    sha256 "4c44a23c1dfe29ec05ac8faec185651343833241be508d5cf1cc70676aa2b6a7" => :yosemite
    sha256 "ef3d9973626fe319d6eb54d80686aad98f5881a32ea6ac509e492193434f026c" => :x86_64_linux
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
