class Nixio < Formula
  desc "C++ library for the NIX scientific data format and model"
  homepage "http://www.g-node.org/nix"
  url "https://github.com/G-Node/nix/archive/1.4.0.tar.gz"
  sha256 "29defada2319691679fa54aadef239fe7bb026aa01933a9b535e8c0628c9578c"
  head "https://github.com/G-Node/nix.git"

  bottle do
    cellar :any
    sha256 "cbed56ed572577cc2df555a25409e12c7b009f4c8202ef90ecc4fb18938e27d7" => :sierra
    sha256 "f34fee34cf20a4f109586c7ac8fb17a14cd5843872e9cd33a15124287ae1a205" => :el_capitan
    sha256 "9b7005718b13554961812808170fcec3831087b3e9e5ac1be42270eba4c706fe" => :yosemite
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
