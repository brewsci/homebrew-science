class Scram < Formula
  desc "Probabilistic Risk Analysis Tool"
  homepage "https://scram-pra.org"
  # Needs to pull submodules to get the customized Tango iconset for Mac.
  url "https://github.com/rakhimov/scram.git",
    :revision => "aa6f9b3737882062af2bc69570bb529ff0f72fd3",
    :tag => "0.15.0"
  revision 1

  head "https://github.com/rakhimov/scram.git"

  bottle do
    sha256 "09d611fe813d13b098758846342d64cdc44b19ac42f1cc6fc4596affb263e07c" => :sierra
    sha256 "af3a7ca19582e7226f8d74b1ac65a2e451a8cf99065c0352df901f7330dc8f51" => :el_capitan
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
