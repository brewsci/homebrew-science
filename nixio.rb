class Nixio < Formula
  desc "C++ library for the NIX scientific data format and model"
  homepage "http://www.g-node.org/nix"
  url "https://github.com/G-Node/nix/archive/1.3.2.tar.gz"
  sha256 "3611c0d4ce4feea6ecb5d104e561678aaa8eca7819f6d3356617b0217400a3c7"
  revision 1
  head "https://github.com/G-Node/nix.git"

  bottle do
    cellar :any
    sha256 "973e305eef9586ef7a7f3e3b8b9c55455a8a4e0e4359f01f01cb9b9c9e854cbc" => :sierra
    sha256 "5edc227d9ab5caf2136c90893f944c95c996fc8ebc9d51fe830cb2de91f9443d" => :el_capitan
    sha256 "25425139d266c000854db8449803cd1cb4147de7b0d8c9a4443366c84c40970c" => :yosemite
    sha256 "82bc9dcb44b0a81e570256615bf9e9acc90aab8019a53010dd40716e2b7b1caa" => :x86_64_linux
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
