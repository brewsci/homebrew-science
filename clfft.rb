class Clfft < Formula
  desc "FFT functions written in OpenCL"
  homepage "https://github.com/clMathLibraries/clFFT/"
  url "https://github.com/clMathLibraries/clFFT/archive/v2.12.1.tar.gz"
  sha256 "3d0c6439730b243fb4890504d4aa71bc1f4d7d3f91dc79e257c5460dab40fcc5"

  bottle do
    cellar :any
    sha256 "18722b98fbc4ac7f1126af400b68cba62086322ab9fad506b39b2673b3d05d89" => :el_capitan
    sha256 "8688d3c1e0812b9a436003bff76ce3c165f619b43a50a30a1884782a44aa330d" => :yosemite
    sha256 "8117363f7b44415324e086f061373e76a7d0ea7a9cc05bdfe1e0e356a8e3fa92" => :mavericks
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
