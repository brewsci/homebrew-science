class Nixio < Formula
  desc "C++ library for the NIX scientific data format and model"
  homepage "http://www.g-node.org/nix"
  url "https://github.com/G-Node/nix/archive/1.4.0.tar.gz"
  sha256 "29defada2319691679fa54aadef239fe7bb026aa01933a9b535e8c0628c9578c"
  head "https://github.com/G-Node/nix.git"

  bottle do
    cellar :any
    sha256 "d93b70c67d35dccfe58f8e92e88fb127cc9d6b94dee66be12236a24866ad32fb" => :sierra
    sha256 "45f0cef18a6b40cb7c7358ea49cc32eaead0d0e65ad7af8c96893c04adffe43e" => :el_capitan
    sha256 "41ffcefd40c8e4cd08b7335cfc8a655273b5ded4e0ead851c4c3a3162ffe5235" => :yosemite
    sha256 "ce54391a0c8400b99759fe8132a6c1eb3914f2df8ad7daef0e4c48722f389c49" => :x86_64_linux
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
