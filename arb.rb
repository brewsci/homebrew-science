class Arb < Formula
  desc "C library for arbitrary-precision floating-point ball arithmetic"
  homepage "http://fredrikj.net/arb/index.html"
  url "https://github.com/fredrik-johansson/arb/archive/2.11.1.tar.gz"
  sha256 "de37f008fd154bd4b9c3fd7f5b0f13928cd109358d01959a98245fe33d08bf63"
  head "https://github.com/fredrik-johansson/arb.git"

  bottle do
    cellar :any
    sha256 "03298f232d02a5c6f19f8d542c412c07bead86a4c3a49e792266779f740b196a" => :sierra
    sha256 "23b3f7c5c4ded5d4d97c3c690204d6f180c9f67d4dcf0ba706a9790d6f84a725" => :el_capitan
    sha256 "e6b665daf94445b76a9e3fd146c845b821958b224a6e5d086b22ae9ef4a03761" => :yosemite
    sha256 "4c0d1a72f3a51b0df884e151215445f7f1bcc10be6bb7720ee27eecee044b52b" => :x86_64_linux
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
