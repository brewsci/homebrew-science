class Clfft < Formula
  desc "FFT functions written in OpenCL"
  homepage "https://github.com/clMathLibraries/clFFT/"
  url "https://github.com/clMathLibraries/clFFT/archive/v2.10.0.tar.gz"
  sha256 "f70d8ae7b8c38f27b4f28e5e7abe55378e18c4f1c5cf8922b561dc908d36ffdc"

  bottle do
    cellar :any
    sha256 "05bc1e1fcd00e72b62a49248c571cb4c52bf16811300ef42712bb2591d1cb5ef" => :el_capitan
    sha256 "ab68153761222e6a665860760dc6ea0505f800b7f04f531739feaa289e55513f" => :yosemite
    sha256 "98835e913cea712dda7a263b23748cc242b2408276fd2cde3536dbc868dc1cca" => :mavericks
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
