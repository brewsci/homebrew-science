require File.expand_path("../Requirements/cuda_requirement", __FILE__)

class Cusp < Formula
  desc "C++ Templated Sparse Matrix Library for CUDA"
  homepage "https://cusplibrary.github.io/"
  url "https://github.com/cusplibrary/cusplibrary/archive/v0.4.0.tar.gz"
  sha256 "8bfcef7fd281bffd53865d74b53cdc69747390c47901a0402bac76cd6442ecda"
  head "https://github.com/cusplibrary/cusplibrary.git", :branch => "develop"

  depends_on CudaRequirement

  def install
    include.install "cusp"
    pkgshare.install "examples"
    pkgshare.install "testing/data"
    (libexec/"bin").install "build"
  end

  test do
    cp pkgshare/"data/laplacian/5pt_10x10.mtx", testpath
    (testpath/"testcusp.cu").write <<-EOS.undent
    #include <thrust/version.h>
    #include <cusp/version.h>
    #include <cusp/hyb_matrix.h>
    #include <cusp/io/matrix_market.h>
    #include <cusp/krylov/cg.h>
    #include <iostream>

    int main(void)
    {
      int cuda_major =  CUDA_VERSION / 1000;
      int cuda_minor = (CUDA_VERSION % 1000) / 10;

      int thrust_major = THRUST_MAJOR_VERSION;
      int thrust_minor = THRUST_MINOR_VERSION;

      int cusp_major = CUSP_MAJOR_VERSION;
      int cusp_minor = CUSP_MINOR_VERSION;

      std::cout << "CUDA   v" << cuda_major   << "." << cuda_minor   << std::endl;
      std::cout << "Thrust v" << thrust_major << "." << thrust_minor << std::endl;
      std::cout << "Cusp   v" << cusp_major   << "." << cusp_minor   << std::endl;

      cusp::hyb_matrix<int, float, cusp::device_memory> A;
      cusp::io::read_matrix_market_file(A, "5pt_10x10.mtx");
      cusp::array1d<float, cusp::device_memory> x(A.num_rows, 0);
      cusp::array1d<float, cusp::device_memory> b(A.num_rows, 1);
      cusp::krylov::cg(A, x, b);
      return 0;
    }
    EOS
    system "nvcc", "testcusp.cu", "-o", "testcusp"
    system "./testcusp"
  end
end
