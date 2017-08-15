class Scram < Formula
  desc "Probabilistic Risk Analysis Tool"
  homepage "https://scram-pra.org"
  # Needs to pull submodules to get the customized Tango iconset for Mac.
  url "https://github.com/rakhimov/scram.git",
    :revision => "aa6f9b3737882062af2bc69570bb529ff0f72fd3",
    :tag => "0.15.0"

  head "https://github.com/rakhimov/scram.git"

  bottle do
    sha256 "8a4f8191ae334d15eb42f24f6d7776027389b5b9c772ce3fe4ea36f57255aff5" => :sierra
    sha256 "5ecca409ff8682096e4cd7abd9e3028fa887b3e17f04810ae0c0e301b956d6d5" => :el_capitan
    sha256 "32cd189a392bba38d4aacbedb05668c5576371fbd943504c66f17e4449ef8cb1" => :yosemite
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
