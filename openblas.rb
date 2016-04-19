class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "http://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.2.15.tar.gz"
  sha256 "73c40ace5978282224e5e122a41c8388c5a19e65a6f2329c2b7c0b61bacc9044"
  head "https://github.com/xianyi/OpenBLAS.git", :branch => "develop"

  bottle do
    cellar :any
    revision 1
    sha256 "f6bae12a433f0557c466fa8b6cf80d67f78413b133b784f0490dbd867e31a6ac" => :el_capitan
    sha256 "12f2043eccf558f65f7d924eee2c6f25c6fa8e2d9f82350f2302caf94b13d400" => :yosemite
    sha256 "f05a958f4ba8a3fd4b90b6dc89d8a986976ed4e3943024e1b8aa10b4ea86c4ec" => :mavericks
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
    so = OS.mac? ? "dylib" : "so"
    ln_s lib/"libopenblas.#{so}", lib/"libblas.#{so}"
    ln_s lib/"libopenblas.#{so}", lib/"liblapack.#{so}"
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
