class Wiggletools < Formula
  desc "Compute genome-wide statistics with composable iterators"
  homepage "https://github.com/Ensembl/WiggleTools"
  url "https://github.com/Ensembl/WiggleTools/archive/v1.2.2.tar.gz"
  sha256 "e9e75b09bcc8aeb012c49937c543e2b05379d3983ba8f6798ca8d6a4171702d9"
  head "https://github.com/Ensembl/WiggleTools.git"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btt737"

  bottle do
    cellar :any
    sha256 "cc1cf9094b43d9dd6a1cbd7d197122dae92e9e405bf2240481ac320d42d46222" => :sierra
    sha256 "6b9e8b7572086b797009999007acbcfeee1d0b2ce8e093b0ff88e7812133306b" => :el_capitan
    sha256 "d6a873265cbf99d142902e6c7d5b67cc59a85ae35585c90db87a87c2c5c41323" => :yosemite
    sha256 "e088b11a3150b631e80534a5fb77637f6a5889e1559d617976b81a2001fc2753" => :x86_64_linux
  end

  depends_on "htslib"
  depends_on "gsl"
  depends_on "curl" unless OS.mac?

  resource "libbigwig" do
    url "https://github.com/dpryan79/libBigWig/archive/0.3.3.tar.gz"
    sha256 "85b5c930bedf9eef84e44c8d4faec28bcffc74362ad56ac3d4321f0e1b532199"
  end

  def install
    resource("libbigwig").stage do
      system "make", "install", "prefix=#{prefix}"
      include.install "bigWig.h"
      lib.install "libBigWig.a", "libBigWig.so"
    end

    cp Dir.glob(include/"*.h"), "src"
    mkdir_p "lib"
    cp lib/"libBigWig.a", "lib"
    system "make"
    pkgshare.install "test"
    lib.install "lib/libwiggletools.a"
    bin.install "bin/wiggletools"
  end

  test do
    cp_r pkgshare/"test", testpath
    cp_r prefix/"bin", testpath
    cd "test" do
      system "python2.7", "test.py"
    end
  end
end
