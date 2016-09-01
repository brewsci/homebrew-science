class Clfft < Formula
  desc "FFT functions written in OpenCL"
  homepage "https://github.com/clMathLibraries/clFFT/"
  url "https://github.com/clMathLibraries/clFFT/archive/v2.12.2.tar.gz"
  sha256 "e7348c146ad48c6a3e6997b7702202ad3ee3b5df99edf7ef00bbacc21e897b12"

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
    cp pkgshare/"examples/fft1d.c", "fft1d.cxx"
    system ENV.cxx, "fft1d.cxx", "-I#{include}", "-L#{lib}", "-lclFFT",
                    "-framework", "OpenCL", "-o", "fft1d"

    # The actual results are incorrect on the Homebrew CI virtual machines
    # but on bare metal the fft result should match (120.000000, 360.000000).
    assert_match "fft result", shell_output("./fft1d")
  end
end
