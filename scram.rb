class Scram < Formula
  desc "Probabilistic Risk Analysis Tool"
  homepage "https://scram-pra.org"
  # Needs to pull submodules to get the customized Tango iconset for Mac.
  url "https://github.com/rakhimov/scram.git",
    :revision => "4031fc55dcd4ca8d611f552ce8d01990ac9a8eee",
    :tag => "0.14.0"

  head "https://github.com/rakhimov/scram.git"

  bottle do
    sha256 "3a501818b0ae9f7a5a749be8ee6038c9f7b769a6f3bb9172b108b7c52630ad18" => :sierra
    sha256 "59693ed39449963019c66edbbb8f3bee91a3962dc4dd75c88e62806f09ca8deb" => :el_capitan
    sha256 "ae0066756d3473adf4ea5939f0da0717ba4fc03162a907d696d56ea065162c9b" => :yosemite
  end

  needs :cxx14

  # C++14 uses GCC 5.3, which is not ABI compatible with GCC 4.8
  depends_on :macos unless OS.mac?

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libxml++"
  depends_on "qt"
  depends_on "gperftools" => :recommended

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DBUILD_SHARED_LIBS=ON" << "-DBUILD_TESTS=OFF"
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/scram", "--help"
    system "#{bin}/scram", "--version"
  end
end
