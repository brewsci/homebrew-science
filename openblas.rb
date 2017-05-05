class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "http://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.2.19.tar.gz"
  sha256 "9c40b5e4970f27c5f6911cb0a28aa26b6c83f17418b69f8e5a116bb983ca8557"
  revision 1
  head "https://github.com/xianyi/OpenBLAS.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "0b05c12758d5f02612ed119f9ee0e252c77f31dc8ea6eb283526d56963aff3e7" => :sierra
    sha256 "e9db7f60028af326379334d8a4aa5bab79b9dac19b13134a9c02cefd8b9a6b25" => :el_capitan
    sha256 "2d140a18160c7dafe28ab331d4cc2f67ceac0e5d2fba6e6152bc3f1206b1b83e" => :yosemite
    sha256 "65b042ab1afe04e53527336a9e8ccd4804fe8fe184bc75b1a2521e2a1c1642f7" => :x86_64_linux
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
