class Nixio < Formula
  desc "C++ library for the NIX scientific data format and model"
  homepage "http://www.g-node.org/nix"
  url "https://github.com/G-Node/nix/archive/1.3.2.tar.gz"
  sha256 "3611c0d4ce4feea6ecb5d104e561678aaa8eca7819f6d3356617b0217400a3c7"
  head "https://github.com/G-Node/nix.git"

  bottle do
    cellar :any
    sha256 "fd1e4844f0e54f596bda88f2e41f437d3e30c8ed4371bd45e46ae7b013011cf2" => :sierra
    sha256 "e149b00bb385e5de24cffce40f2134a9d9150dd6754eac7459757e80a8c5ff99" => :el_capitan
    sha256 "dabcc61a759654f18f05440f79bf482c991bee447b0e6836ce39f77064f2c48e" => :yosemite
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
