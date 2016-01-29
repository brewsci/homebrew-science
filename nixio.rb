class Nixio < Formula
  desc "C++ library for the NIX scientific data format and model"
  homepage "http://www.g-node.org/nix"
  url "https://github.com/G-Node/nix/archive/1.1.0.tar.gz"
  sha256 "d607d96117621e5cc563002c4c161913d95db36eeb7c4e6f51afca5f6b788fcc"

  head "https://github.com/G-Node/nix.git"

  bottle do
    cellar :any
    sha256 "9cb0f5f3b4d25e4e53bee32223b97ded9bfe4ee5763954b2a4415655f968a678" => :el_capitan
    sha256 "642a99210080298f004546242334f1d43caedaba0b5c1aeee79c697b28f6317b" => :yosemite
    sha256 "34b92b846c587d96b58a2dbcbf52c77d01955e0d27c921c62bd019371a2010a8" => :mavericks
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
