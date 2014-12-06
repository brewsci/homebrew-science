require "formula"

class Flint < Formula
  homepage "http://flintlib.org"
  #doi "10.1007/978-3-642-15582-6_18"
  #tag "math"
  url "http://flintlib.org/flint-2.4.4.tar.gz"
  sha1 "71075ce6d851af6244110644479bf29b4403212c"
  head "https://github.com/wbhart/flint2.git", :branch => "trunk"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "617731bca8e304ff9351c0fbee22ac078bbeee5e" => :yosemite
    sha1 "ec020b7499a3b7d19fa4a2c44d2abc30d34c21aa" => :mavericks
    sha1 "29dbbfc5cf472a0922376ec47e40975b9caec6bb" => :mountain_lion
  end

  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath / "test.c").write <<-EOS.undent
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
