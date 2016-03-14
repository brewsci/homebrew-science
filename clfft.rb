class Clfft < Formula
  desc "FFT functions written in OpenCL"
  homepage "https://github.com/clMathLibraries/clFFT/"
  url "https://github.com/clMathLibraries/clFFT/archive/v2.10.0.tar.gz"
  sha256 "f70d8ae7b8c38f27b4f28e5e7abe55378e18c4f1c5cf8922b561dc908d36ffdc"

  bottle do
    cellar :any
    sha256 "615b58ba255381b82f90d63866ba6c6431a45c7af6226569c25176c835e688b6" => :el_capitan
    sha256 "0b6ca452b5ea924d320c5e9971b593d80ecb360656021effb38ad0237c358b29" => :yosemite
    sha256 "f5c2aa97b3cf6add9d2c528d84c4744ff970b65e23aa63586a3c4c10d3bcaa4f" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "boost" => :build

  def install
    mkdir "build"
    cd "build" do
      system "cmake", "../src", "-DBUILD_EXAMPLES:BOOL=OFF", "-DBUILD_TEST:BOOL=OFF", *std_cmake_args
      system "make", "install"
    end
    pkgshare.install "src/examples"
  end

  test do
    system ENV.cxx, "#{pkgshare}/examples/fft1d.c", "-I#{opt_include}", "-L#{opt_lib}", "-lclFFT", "-framework", "OpenCL", "-o", "fft1d"
    assert_match "(120.000000, 360.000000)", `./fft1d`
  end
end
