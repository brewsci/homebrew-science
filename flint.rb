class Flint < Formula
  homepage "http://flintlib.org"
  #doi "10.1007/978-3-642-15582-6_18"
  #tag "math"
  url "http://flintlib.org/flint-2.4.5.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/f/flint/flint_2.4.5.orig.tar.gz"
  sha256 "e489354df00f0d84976ccdd0477028693977c87ccd14f3924a89f848bb0e01e3"
  head "https://github.com/wbhart/flint2.git", :branch => "trunk"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "791a7d2fc59c971a8201a3b81b7a5d4315165b58ba9c2b5b3807111d9e9896ad" => :yosemite
    sha256 "499a90a4ab6d7783fcf43fa35428f90b5923c7a28722474231736668d9b1f26a" => :mavericks
    sha256 "e82ce164d3161c934971f674a5459ee9a354baf7b4c4d4cca7f2bd5006a626d0" => :mountain_lion
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
