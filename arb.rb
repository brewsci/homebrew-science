class Arb < Formula
  desc "C library for arbitrary-precision floating-point ball arithmetic"
  homepage "http://fredrikj.net/arb/index.html"
  url "https://github.com/fredrik-johansson/arb/archive/2.5.0.tar.gz"
  sha256 "1c741b3d7c7a350c01572fb9cdd8218049c669409dff21c1a569a163942e4803"
  head "https://github.com/fredrik-johansson/arb.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6fc16931a8baa38235344a0876c1b9b4b245770ef4780027d7af41f71641c611" => :sierra
    sha256 "4bbb15a225d7533491f998d920ed80edb643726fab7037703ca1863d213f78a0" => :el_capitan
    sha256 "31656464034a68399d2572021f4a76e8834d3b6434dfa989bfd058ef2c3eae6a" => :yosemite
    sha256 "55f4656b03aae0ebac69b732ada10540dd571666282ad1452e3b00377299ebc9" => :mavericks
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "flint"

  # Will be enabled once the new stable (with patched tests) is released
  # some of the tests in 2.5.0 are broken because they call not yet implemented
  # methods
  # option "with-check", "Enable build-time checking (not recommended)"

  def install
    system "./configure", "--prefix=#{prefix}"
    # We need to remove this line to have 2.5.0 compiled on OSX
    # it is fixed in the new version, this line will disappear then
    inreplace "Makefile", "$(QUIET_AR) $(AR) rcs libarb.a $(OBJS);", ""
    system "make"
    # Will be enabled once the new stable (with patched tests) is released
    # see above
    # system "make", "check" if build.with? "check"
    system "make", "install"
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
