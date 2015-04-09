class Arb < Formula
  homepage "http://fredrikj.net/arb/index.html"
  url "https://github.com/fredrik-johansson/arb/archive/2.5.0.tar.gz"
  sha256 "1c741b3d7c7a350c01572fb9cdd8218049c669409dff21c1a569a163942e4803"
  head "https://github.com/fredrik-johansson/arb.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "f197f70e77fef5508015282639034df17e14f99e76c9d3e80376982529fce302" => :yosemite
    sha256 "a25d7f83620b4e73410e578c40a436ec9113045ebcfecea337a8416b87cd81de" => :mavericks
    sha256 "6e199a91de0f513d08c90370032f946057256cec12306b4db6ff05fabd42b31d" => :mountain_lion
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
