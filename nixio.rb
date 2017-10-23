class Nixio < Formula
  desc "C++ library for the NIX scientific data format and model"
  homepage "http://www.g-node.org/nix"
  url "https://github.com/G-Node/nix/archive/1.4.1.tar.gz"
  sha256 "6b559744d36b6212a35a8c82db5829ec8feeac87bf0732686bef5e2cd7c9d8a9"
  head "https://github.com/G-Node/nix.git"

  bottle do
    cellar :any
    sha256 "bcda7acafc7fee3cc7e76f5b9330e01079a61b6a8ef4f8a295ef1e50f6209758" => :high_sierra
    sha256 "8f731dcfc9694f7147b56e5fab86ac3ea7665a757f91e5d15003feb490135ea1" => :sierra
    sha256 "024348193cd60947cae15fa918e3aa90ca6c757c4325a7154e66b817cffac301" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "cppunit"
  depends_on "boost"

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
