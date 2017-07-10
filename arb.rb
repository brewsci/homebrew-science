class Arb < Formula
  desc "C library for arbitrary-precision floating-point ball arithmetic"
  homepage "http://fredrikj.net/arb/index.html"
  url "https://github.com/fredrik-johansson/arb/archive/2.11.1.tar.gz"
  sha256 "de37f008fd154bd4b9c3fd7f5b0f13928cd109358d01959a98245fe33d08bf63"
  head "https://github.com/fredrik-johansson/arb.git"

  bottle do
    cellar :any
    sha256 "7cea38ebba9f240b3ae23f27921a2dbb54ea492cb2311057677eea5993edbab8" => :sierra
    sha256 "41e047c2667866cb1e4a05ed3a2027ee75d48d3a2317073fa0243f3ad76334f9" => :el_capitan
    sha256 "21817578932665a61a8a4ad63b6132ed8822a7541a7b7304e508a145ff893221" => :yosemite
    sha256 "517806588e1d2511e40dba2e4ac525f1d08a268fa0492a1edb5521aee6ff30ca" => :x86_64_linux
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
