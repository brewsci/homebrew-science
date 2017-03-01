require File.expand_path("../Requirements/cuda_requirement", __FILE__)

class Einspline < Formula
  desc "C library for cubic B-splines in 1, 2 and 3D"
  homepage "https://einspline.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/einspline/einspline-0.9.2.tar.gz"
  sha256 "fc9ec0475f7711ef711c8b6ea28d3dd11a173adaa381df80c2df4c5cc22d4afe"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f66a26ba0e61f0787e41f2a35e3b8a71f408a1c8e755e27f14c777102ca1f4bc" => :el_capitan
    sha256 "1200fc9020a7df9d4179b72c309bf1ee12c130140699f1c65762c3f59b611817" => :yosemite
    sha256 "825439011bdb1fa953863b8b5a6af0b4faa328d1661c051946029e8ca7b9441a" => :mavericks
  end

  option "without-openmp", "Disable OpenMP"

  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on :fortran
  depends_on CudaRequirement => :optional

  needs :openmp if build.with? "openmp"

  fails_with :clang do
    cause "Clang does not support variable-length arrays for non-POD types."
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-sse
      --enable-pthread
      --enable-static
    ]
    args << "--enable-cuda" if build.with? "cuda"
    # args << "--enable-openmp" if build.with? "openmp" # leads to build errors.
    cflags = %W[
      -DINLINE_ALL=inline
      -O3
      -Drestrict=__restrict__
      -finline-limit=1000
      -fstrict-aliasing
      -funroll-all-loops
      -Wno-deprecated
      -fomit-frame-pointer
    ]
    cflags << "-fopenmp" if build.with? "openmp"
    ENV["CXXFLAGS"] = cflags.join(" ")
    ENV["CFLAGS"] = cflags.join(" ")
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Spline evaluation functions have been inlined.
    Do not forget to compile your code with
    -O, -O2 or -O3.
    EOS
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include "einspline/bspline.h"
      #include <stdio.h>

      int main(void) {
        Ugrid grid;
        grid.start = 1.0;
        grid.end   = 3.0;
        grid.num = 11;
        double data[] = { 3.0, -4.0, 2.0, 1.0, -2.0, 0.0, 3.0, 2.0, 0.5, 1.0, 3.0 };
        BCtype_d bc;
        bc.lCode = DERIV1; bc.lVal = 10.0;
        bc.rCode = DERIV2; bc.rVal = -10.0;

        UBspline_1d_d *spline = (UBspline_1d_d*) create_UBspline_1d_d(grid, bc, data);
        for (double x = 1.0; x <= 3.1; x += 0.1) {
          double val, grad, lapl;
          eval_UBspline_1d_d_vgl(spline, x, &val, &grad, &lapl);
          printf("%1.5f %20.14f %20.14f %20.14f\\n", x, val, grad, lapl);
        }
        return 0;
      }
    EOS
    system ENV["CC"], "test.c", "-O", "-I#{opt_include}", "-L#{opt_lib}", "-leinspline", "-o", "test"
    system "./test"
  end
end
