class Clblas < Formula
  desc "Library containing BLAS functions written in OpenCL"
  homepage "https://github.com/clMathLibraries/clBLAS"
  url "https://github.com/clMathLibraries/clBLAS/archive/v2.6.tar.gz"
  sha256 "4607561a648949709bc7c368be4aaf7346174406e678454b643e31cfe861830c"

  bottle do
    cellar :any
    sha256 "95e08bbfde36c49f8f4fae3f420980d329c67215f7198475f34a0bae22a05f4f" => :yosemite
    sha256 "0315da2f6b54edfff65315709f2d16cc9c9514adafa2ea7400b6a759f16001c1" => :mavericks
    sha256 "665bd59d4dc12933722003a7092eea19104ef5722aacfdc27e423c988df0f5ca" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "boost" => :build

  def install
    args = std_cmake_args
    args << "-DBUILD_TEST=OFF"
    args << "-DBUILD_CLIENT=ON"
    args << "-DBUILD_KTEST=OFF"
    args << "-DSUFFIX_LIB:STRING="
    args << "-DCMAKE_MACOSX_RPATH:BOOL=ON"
    system "cmake", "src", *args
    system "make", "install"
  end

  test do
    system "#{bin}/clBLAS-client", "--cpu"
  end
end
