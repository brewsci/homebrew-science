class Flint < Formula
  desc "C library for number theory"
  homepage "http://flintlib.org"
  # doi "10.1007/978-3-642-15582-6_18"
  # tag "math"
  url "http://flintlib.org/flint-2.5.2.tar.gz"
  sha256 "cbf1fe0034533c53c5c41761017065f85207a1b770483e98b2392315f6575e87"
  revision 1
  head "https://github.com/wbhart/flint2.git", :branch => "trunk"

  bottle do
    sha256 "84ea34a38641727ba22c55f9b1822fb3b7d6a7cf4aa7df3276b0414e02e13aa7" => :high_sierra
    sha256 "1449026475aeb11f36bcd1d7406f6cf33df7ad63e67ccca034611e4383666281" => :sierra
    sha256 "100c43d9c54a3ce171fdbea0156423e63f6a10e3fe53f291aabac7cb89d2aa2d" => :el_capitan
    sha256 "2b5aa1e178f556652bdfca7db76f9adbfe781abfe9a2925e448b79656676ccad" => :x86_64_linux
  end

  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-gmp=#{Formula["gmp"].opt_prefix}",
                          "--with-mpfr=#{Formula["mpfr"].opt_prefix}",
                          "--disable-tls"
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
