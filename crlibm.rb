class Crlibm < Formula
  homepage "http://lipforge.ens-lyon.fr/www/crlibm/"
  url "http://lipforge.ens-lyon.fr/frs/download.php/162/crlibm-1.0beta4.tar.gz"
  sha256 "6836b4299f9421c99da2bdcd5e04a8d35577db4eb61161a401aa93751a96375d"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <math.h>
      #include <crlibm.h>

      int main(void){
        double x = 0.314, res_libm, res_crlibm;

        crlibm_init();
        res_libm = cos(x);
        res_crlibm = cos_rn(x);
        printf("x = %.25lf\\n", x);
        printf("cos(x) with the system : %.25lf\\n", res_libm);
        printf("cos(x) with crlibm     : %.25lf\\n", res_crlibm);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lm", "-lcrlibm", "-o", "test"
    system "./test"
  end
end
