class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "http://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.2.19.tar.gz"
  sha256 "9c40b5e4970f27c5f6911cb0a28aa26b6c83f17418b69f8e5a116bb983ca8557"
  head "https://github.com/xianyi/OpenBLAS.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "58d25ac37a97f1dcb68aa250794de9f1282367b51affd4d712fa82de6ac6712d" => :sierra
    sha256 "ec1643981131ee4ee94d32e800b1c0f5ae6969ca0e0a5bc46fde414d032e6330" => :el_capitan
    sha256 "3e38ba0140b24f8e2679f132a15d04a413cf946abe6319b94b856048af493031" => :yosemite
  end

  # OS X provides the Accelerate.framework, which is a BLAS/LAPACK impl.
  keg_only :provided_by_osx

  patch do
    # Change file comments to work around clang 3.9 assembler bug
    # https://github.com/xianyi/OpenBLAS/pull/982
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/9c8a1cc/openblas/openblas0.2.19.diff"
    sha256 "3ddabb73abf3baa4ffba2648bf1d9387bbc6354f94dd34eeef942f1b3e25c29a"
  end

  option "with-openmp", "Do parallel computation with OpenMP"
  needs :openmp if build.with? "openmp"

  depends_on :fortran

  def install
    ENV["DYNAMIC_ARCH"] = "1" if build.bottle?
    ENV["USE_OPENMP"] = "1" if build.with? "openmp"

    # Must call in two steps
    system "make", "CC=#{ENV["CC"]}", "FC=#{ENV["FC"]}", "libs", "netlib", "shared"
    system "make", "CC=#{ENV["CC"]}", "FC=#{ENV["FC"]}", "tests"
    system "make", "PREFIX=#{prefix}", "install"
    so = OS.mac? ? "dylib" : "so"
    lib.install_symlink "libopenblas.#{so}" => "libblas.#{so}"
    lib.install_symlink "libopenblas.#{so}" => "liblapack.#{so}"
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
