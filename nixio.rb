class Nixio < Formula
  desc "C++ library for the NIX scientific data format and model"
  homepage "http://www.g-node.org/nix"
  url "https://github.com/G-Node/nix/archive/1.3.2.tar.gz"
  sha256 "3611c0d4ce4feea6ecb5d104e561678aaa8eca7819f6d3356617b0217400a3c7"
  revision 3
  head "https://github.com/G-Node/nix.git"

  bottle do
    cellar :any
    sha256 "d93b70c67d35dccfe58f8e92e88fb127cc9d6b94dee66be12236a24866ad32fb" => :sierra
    sha256 "45f0cef18a6b40cb7c7358ea49cc32eaead0d0e65ad7af8c96893c04adffe43e" => :el_capitan
    sha256 "41ffcefd40c8e4cd08b7335cfc8a655273b5ded4e0ead851c4c3a3162ffe5235" => :yosemite
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
