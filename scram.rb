class Scram < Formula
  desc "Probabilistic Risk Analysis Tool"
  homepage "https://scram-pra.org"
  # Needs to pull submodules to get the customized Tango iconset for Mac.
  url "https://github.com/rakhimov/scram.git",
    :revision => "cccecbf9286a6aee945538ca4dd9141f64714f79",
    :tag => "0.16.0"

  head "https://github.com/rakhimov/scram.git"

  bottle do
    sha256 "71b89eef9dd9765cf295e108d8607cd495318a23dfab88fae4e8e4e624b4f021" => :high_sierra
    sha256 "fe7025dc570e1752e76c0ad6b6b4df683492a23aa5eccb6e6f0bc53ef43ffff4" => :sierra
    sha256 "e2fa4d3d270fe7a5ab29eef7ebc9b493970d9bdc9670e771a7969107791b6791" => :el_capitan
  end

  needs :cxx14

  # C++14 uses GCC 5.3, which is not ABI compatible with GCC 4.8
  depends_on :macos unless OS.mac?

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libxml2"
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
