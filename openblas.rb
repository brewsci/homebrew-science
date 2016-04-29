class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "http://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.2.18.tar.gz"
  sha256 "7d9f8d4ea4a65ab68088f3bb557f03a7ac9cb5036ef2ba30546c3a28774a4112"
  head "https://github.com/xianyi/OpenBLAS.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "ec121967cdbee65fd07a0ce43bcf7260f5c6d4360ab792a05958adf4a5d94a37" => :el_capitan
    sha256 "f0c87b50cfa83d1869a34b2c3dd2f55f4fc7bd2d2ab58c4500079b9cb8800c1e" => :yosemite
    sha256 "57d330e26b17134d0850f03e7de876e8b53d735687aeb01051133dc85bc1cb96" => :mavericks
  end

  # OS X provides the Accelerate.framework, which is a BLAS/LAPACK impl.
  keg_only :provided_by_osx

  option "with-openmp", "Do parallel computation with OpenMP"
  needs :openmp if build.with? "openmp"

  depends_on :fortran

  def install
    ENV["DYNAMIC_ARCH"] = "1" if build.bottle?
    ENV["USE_OPENMP"] = "1" if build.with? "openmp"

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
