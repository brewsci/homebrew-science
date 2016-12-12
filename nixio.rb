class Nixio < Formula
  desc "C++ library for the NIX scientific data format and model"
  homepage "http://www.g-node.org/nix"
  url "https://github.com/G-Node/nix/archive/1.2.0.tar.gz"
  sha256 "663da5a2b464c162979c73f28d42b08385adced70746cf78aeb1c1e26ee14272"
  revision 1
  head "https://github.com/G-Node/nix.git"

  bottle do
    cellar :any
    sha256 "90b2900942a63c60d3acc7748d788e05fc0a8c8a3b8392083e476a9408d4f4ca" => :sierra
    sha256 "b37e8335f9c00589bc1901dcfde25cdca2a846dd8342bd85d6ce7b44e8ebf25b" => :el_capitan
    sha256 "0aa6d4dfe67c4aa72d727ba9c841fa9f041803ac6c2ede8bf3ab96ec14825d32" => :yosemite
    sha256 "03863ee45f953aac15581f435cbe9edaf6d2bab633645c4ff179d4318303065e" => :x86_64_linux
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
