class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "http://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.2.18.tar.gz"
  sha256 "7d9f8d4ea4a65ab68088f3bb557f03a7ac9cb5036ef2ba30546c3a28774a4112"
  revision 2
  head "https://github.com/xianyi/OpenBLAS.git", :branch => "develop"

  bottle do
    cellar :any
    revision 1
    sha256 "617d14f7d52b594bcd0cc9bf9e1b32a61b9854c3f2245d9aa9671e8b9fbb3563" => :el_capitan
    sha256 "302263ab9802a45e8a50da29181b397f538959c9fd103a81a65ad5b13be12fe5" => :yosemite
    sha256 "a7b6354036ed34040d64d382d208fb7293369767806a78238bb29c60858f0bd4" => :mavericks
    sha256 "52ed6d2b81d70c9db8d85db53de64ec2b9cf0ad3ab05cbc3f5c214dfab54a740" => :x86_64_linux
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
