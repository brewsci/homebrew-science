class Arb < Formula
  desc "C library for arbitrary-precision floating-point ball arithmetic"
  homepage "http://fredrikj.net/arb/index.html"
  url "https://github.com/fredrik-johansson/arb/archive/2.8.1.tar.gz"
  sha256 "f4f4ec2d59b348c5e89eaf0b33734bce83a2ef85ab4748b24b984d07f5651012"
  head "https://github.com/fredrik-johansson/arb.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6fc16931a8baa38235344a0876c1b9b4b245770ef4780027d7af41f71641c611" => :sierra
    sha256 "4bbb15a225d7533491f998d920ed80edb643726fab7037703ca1863d213f78a0" => :el_capitan
    sha256 "31656464034a68399d2572021f4a76e8834d3b6434dfa989bfd058ef2c3eae6a" => :yosemite
    sha256 "55f4656b03aae0ebac69b732ada10540dd571666282ad1452e3b00377299ebc9" => :mavericks
  end

  option "without-test", "Disable build-time checking (not recommended)"

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "flint"

  def install
    ENV.prepend "CFLAGS", "-I#{Formula["flint"].opt_include}/flint"
    system "./configure", "--prefix=#{prefix}"
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
