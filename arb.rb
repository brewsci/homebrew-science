class Arb < Formula
  desc "C library for arbitrary-precision floating-point ball arithmetic"
  homepage "http://fredrikj.net/arb/index.html"
  url "https://github.com/fredrik-johansson/arb/archive/2.9.0.tar.gz"
  sha256 "98f6f543e41e5dcb62cc6204d607fefa88317388c54c2a8edb9e601f7d243142"
  head "https://github.com/fredrik-johansson/arb.git"

  bottle do
    cellar :any
    sha256 "ab5f1dbe1bf3cd50a4e7aef3c46f17db65505fa023288c09f055ca8039bda431" => :sierra
    sha256 "30eaaca98a509db97c7122e312da4ec05ee1a83645e79d02d21944b5194cd649" => :el_capitan
    sha256 "1284efa410c2b3c2159c25e53b6f2e60affe92e2e624d81ed29474c6d4b193eb" => :yosemite
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
