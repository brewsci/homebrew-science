class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "http://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.2.15.tar.gz"
  sha256 "73c40ace5978282224e5e122a41c8388c5a19e65a6f2329c2b7c0b61bacc9044"
  head "https://github.com/xianyi/OpenBLAS.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "f5a6261deee618939ea91fc22310a03dedb395f8004ea209e60b8714a91ef39e" => :el_capitan
    sha256 "ad5f388d809441ea2b07c3e6f32a0f6737fbe29e3e11d15d810d56726a800f8e" => :yosemite
    sha256 "2ca40b10b27dc8253dca76c3e482ee5a55d54f5dbc26ad7faee1f5801c1b1113" => :mavericks
  end

  # OS X provides the Accelerate.framework, which is a BLAS/LAPACK impl.
  keg_only :provided_by_osx

  depends_on :fortran

  def install
    ENV["DYNAMIC_ARCH"] = "1" if build.bottle?

    # Must call in two steps
    system "make", "FC=#{ENV["FC"]}", "libs", "netlib", "shared"
    system "make", "FC=#{ENV["FC"]}", "tests"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <cblas.h>
      #include <stdio.h>

      int main(void) {
        int i=0;
        double A[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double B[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double C[9] = {.5, .5, .5, .5, .5, .5, .5, .5, .5};
        cblas_dgemm(CblasColMajor, CblasNoTrans, CblasTrans,
                    3, 3, 2, 1, A, 3, B, 3, 2, C, 3);

        for (i = 0; i < 9; i++)
          printf("%lf ", C[i]);
        printf("\\n");
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lopenblas", "-o", "test"
    system "./test"
  end
end
