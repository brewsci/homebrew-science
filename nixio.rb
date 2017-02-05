class Nixio < Formula
  desc "C++ library for the NIX scientific data format and model"
  homepage "http://www.g-node.org/nix"
  url "https://github.com/G-Node/nix/archive/1.3.2.tar.gz"
  sha256 "3611c0d4ce4feea6ecb5d104e561678aaa8eca7819f6d3356617b0217400a3c7"
  revision 1
  head "https://github.com/G-Node/nix.git"

  bottle do
    cellar :any
    sha256 "9e44a40e24854d7c8a68738774fc212981317527ad98e92848c12a1b7e65cfe1" => :sierra
    sha256 "719f880d2fa12f670097d6d0f7d991ed47e6530d6cb65e5ef4e8f7d740b94c2d" => :el_capitan
    sha256 "02a8fd8144a9d37d3f9143cba399ef4470ef0af5cf694a02dcfe2962f6afabb8" => :yosemite
    sha256 "8a1a493db650abed35b88d9636a3ef0007831c967047762f1f954279e31afc23" => :x86_64_linux
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
