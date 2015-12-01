class Flint < Formula
  desc "C library for number theory"
  homepage "http://flintlib.org"
  # doi "10.1007/978-3-642-15582-6_18"
  # tag "math"
  url "http://flintlib.org/flint-2.5.2.tar.gz"
  sha256 "cbf1fe0034533c53c5c41761017065f85207a1b770483e98b2392315f6575e87"
  head "https://github.com/wbhart/flint2.git", :branch => "trunk"

  bottle do
    cellar :any
    sha256 "7e8fa93f1f42993b5f435beecf72d3e5e5823a8d36690ef064648af3350c359c" => :el_capitan
    sha256 "89f67c073a026844c203461dd45bc31bea044f68ce839ec942a5409e29f75084" => :yosemite
    sha256 "aa79fae7ae0f8b0c0adf9c3dbd1f2b4bf83d8d8904cdf921416605ed25ee1eb4" => :mavericks
  end

  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "./configure", "--prefix=#{prefix}"
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
