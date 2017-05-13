class Scram < Formula
  desc "Probabilistic Risk Analysis Tool"
  homepage "https://scram-pra.org/"
  url "https://github.com/rakhimov/scram/archive/0.13.0.tar.gz"
  sha256 "01c4c3cd98e4a197e2b71b85f3953896e75030f5b70970b65fa5a67dbbdc532a"

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
  depends_on "gperftools" => :recommended

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DBUILD_SHARED_LIBS=OFF" << "-DINSTALL_LIBS=OFF"
      args << "-DBUILD_GUI=OFF" << "-DBUILD_TESTS=OFF"
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/scram", "--help"
    system "#{bin}/scram", "--version"
  end
end
