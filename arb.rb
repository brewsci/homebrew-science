class Arb < Formula
  desc "C library for arbitrary-precision floating-point ball arithmetic"
  homepage "http://fredrikj.net/arb/index.html"
  url "https://github.com/fredrik-johansson/arb/archive/2.9.0.tar.gz"
  sha256 "98f6f543e41e5dcb62cc6204d607fefa88317388c54c2a8edb9e601f7d243142"
  head "https://github.com/fredrik-johansson/arb.git"

  bottle do
    cellar :any
    sha256 "f0f03ca2d991d0ef14e6d462abe264ae51d5e043c53cf1847e2eeeccf602b13a" => :sierra
    sha256 "9b0cc6b525d43de410d13355cac7e017335d763f3829ffdfb84b02ce8717ec8a" => :el_capitan
    sha256 "fdecf433a02d64446c8e64355733fc57dcd11225328bf545b600a7cd5b9627cf" => :yosemite
  end

  option "without-test", "Disable build-time checking (not recommended)"

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "flint"

  def install
    if OS.mac?
      inreplace "Makefile.in" do |s|
        s.gsub! "ln -sf \"$(ARB_LIB)\" \"$(ARB_LIBNAME).$(ARB_MAJOR)\";",
                "ln -sf \"$(ARB_LIB)\" \"libarb.$(ARB_MAJOR).dylib\";"
        s.gsub! "cp -a $(shell ls $(ARB_LIBNAME)*) \"$(DESTDIR)$(PREFIX)/$(LIBDIR)\";",
                "cp -a $(shell ls libarb*) \"$(DESTDIR)$(PREFIX)/$(LIBDIR)\";"
      end
    end

    ENV.prepend "CFLAGS", "-I#{Formula["flint"].opt_include}/flint"
    system "./configure", "--prefix=#{prefix}",
                          "--with-gmp=#{Formula["gmp"].opt_prefix}",
                          "--with-mpfr=#{Formula["mpfr"].opt_prefix}",
                          "--with-flint=#{Formula["flint"].opt_prefix}"
    system "make"
    system "make", "install"
    system "make", "check" if build.with? "test"
  end

  test do
    (testpath / "test.c").write <<-EOS.undent
      #include <stdio.h>
      #include "arb.h"

      int main()
      {
        arb_t x;
        arb_init(x);
        arb_const_pi(x, 50 * 3.33);
        arb_printn(x, 50, 0);
        printf("\\nComputed with arb-%s\\n", arb_version);
        arb_clear(x);

        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-larb", "-lflint", "-I#{Formula["flint"].include}/flint", "-o", "test"
    system "./test"
  end
end
