class Flint < Formula
  desc "C library for number theory"
  homepage "http://flintlib.org"
  # doi "10.1007/978-3-642-15582-6_18"
  # tag "math"
  url "http://flintlib.org/flint-2.5.2.tar.gz"
  sha256 "cbf1fe0034533c53c5c41761017065f85207a1b770483e98b2392315f6575e87"
  head "https://github.com/wbhart/flint2.git", :branch => "trunk"

  bottle do
    revision 1
    sha256 "c1f138713448831b1c0b7139f8b5f6e5db1efa24ea36e362fa034b7583b4dfd2" => :el_capitan
    sha256 "7d9eb3063db06aeba1e2f56dc996f18ec956ac5cebb119b0f3b731f616d87158" => :yosemite
    sha256 "698ffed40c561b5235aff6e4fd577786ceb28b0c0de3fb5a708401ad0dc1bba4" => :mavericks
  end

  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-gmp=#{Formula["gmp"].opt_prefix}",
                          "--with-mpfr=#{Formula["mpfr"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdlib.h>
      #include <stdio.h>
      #include <gmp.h>

      #include <flint/flint.h>
      #include <flint/fmpz_mod_poly.h>

      int main(int argc, char* argv[])
      {
          fmpz_t n;
          fmpz_mod_poly_t x, y;

          fmpz_init_set_ui(n, 7);
          fmpz_mod_poly_init(x, n);
          fmpz_mod_poly_init(y, n);
          fmpz_mod_poly_set_coeff_ui(x, 3, 5);
          fmpz_mod_poly_set_coeff_ui(x, 0, 6);
          fmpz_mod_poly_sqr(y, x);
          fmpz_mod_poly_print(x); flint_printf("\\n");
          fmpz_mod_poly_print(y); flint_printf("\\n");
          fmpz_mod_poly_clear(x);
          fmpz_mod_poly_clear(y);
          fmpz_clear(n);

          return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-lgmp", "-lflint", "-o", "test"
    system "./test"
  end
end
