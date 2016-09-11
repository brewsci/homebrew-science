class Nixio < Formula
  desc "C++ library for the NIX scientific data format and model"
  homepage "http://www.g-node.org/nix"
  url "https://github.com/G-Node/nix/archive/1.1.0.tar.gz"
  sha256 "d607d96117621e5cc563002c4c161913d95db36eeb7c4e6f51afca5f6b788fcc"
  revision 3

  head "https://github.com/G-Node/nix.git"

  bottle do
    cellar :any
    sha256 "9ba0a2b8f922be3c83a45ef8c6502ec773cc5824b355cf38128dd1e27c02b36b" => :el_capitan
    sha256 "b1cd780b3b2e0f095a2d22ea5277f69d3c3cb2b86ef407883b4905c2ef5d07d7" => :yosemite
    sha256 "ac762654d8b9691fd20476decb1cb7bb3f9089b857bea6d1a9475f64f601989e" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "cppunit"

  if OS.mac? && MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  needs :cxx11

  resource "demofile" do
    url "https://raw.githubusercontent.com/G-Node/nix-demo/master/data/spike_features.h5"
    sha256 "b486202df0527545cd53968545d5fb3700567dbf10fbf7d9ca9d9a98fe2998ac"
  end

  def install
    ENV.cxx11

    # https://github.com/G-Node/nix/pull/622
    inreplace "CMakeLists.txt", "(nix CXX)", "(nix C CXX)" unless build.head?

    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    resource("demofile").stage do
      system bin/"nix-tool", "dump", "spike_features.h5"
    end
  end
end
