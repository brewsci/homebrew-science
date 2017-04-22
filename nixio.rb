class Nixio < Formula
  desc "C++ library for the NIX scientific data format and model"
  homepage "http://www.g-node.org/nix"
  url "https://github.com/G-Node/nix/archive/1.3.2.tar.gz"
  sha256 "3611c0d4ce4feea6ecb5d104e561678aaa8eca7819f6d3356617b0217400a3c7"
  revision 2
  head "https://github.com/G-Node/nix.git"

  bottle do
    cellar :any
    sha256 "c668ceabf1e629e42eba5dc1dc0bd4008c56e99dd5eb95dc9afcf945527540ae" => :sierra
    sha256 "58ee5434820452a28a87f23264348540cf7a157fdc0c88aafc079234bff52850" => :el_capitan
    sha256 "f6c4d7f7a9b9ace1f97865ef3776b67418526e9ef84c94c0c6c5243e9fe8dc19" => :yosemite
    sha256 "d5a6222a2829c8b8e38ca5c5e15068cc0424b18b07b6c1a6b64ecc5945ee6f6f" => :x86_64_linux
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
