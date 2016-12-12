class Nixio < Formula
  desc "C++ library for the NIX scientific data format and model"
  homepage "http://www.g-node.org/nix"
  url "https://github.com/G-Node/nix/archive/1.2.0.tar.gz"
  sha256 "663da5a2b464c162979c73f28d42b08385adced70746cf78aeb1c1e26ee14272"
  revision 1
  head "https://github.com/G-Node/nix.git"

  bottle do
    cellar :any
    sha256 "9d5eef06cd610953599aefa126b627d6602fb8d2217ab7af473436e979564637" => :sierra
    sha256 "a376b2c89011e00b34f2db1f30b6872bb1335923dcf1f88f5556cc4596a064df" => :el_capitan
    sha256 "321f02bd31ab9889362259d75a273e5624878da337ff9d6a352aa9c291cfe251" => :yosemite
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
