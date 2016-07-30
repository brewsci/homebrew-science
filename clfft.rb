class Clfft < Formula
  desc "FFT functions written in OpenCL"
  homepage "https://github.com/clMathLibraries/clFFT/"
  url "https://github.com/clMathLibraries/clFFT/archive/v2.12.1.tar.gz"
  sha256 "3d0c6439730b243fb4890504d4aa71bc1f4d7d3f91dc79e257c5460dab40fcc5"

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
