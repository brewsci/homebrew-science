class Kmc < Formula
  desc "Fast and frugal disk based k-mer counter"
  homepage "http://sun.aei.polsl.pl/kmc/"
  # doi "10.1093/bioinformatics/btv022"
  # tag "bioinformatics"

  url "https://github.com/marekkokot/KMC/archive/2.3.tar.gz"
  sha256 "829fd983db883f09c07e533292e0452d79256a76b5dc9ca2be2392368358eafe"

  head "https://github.com/marekkokot/KMC.git"

  bottle do
    sha256 "b032543b37c84dabd62521956aa089d00cceee494644cc7b587ad9bc22b7db8e" => :el_capitan
    sha256 "4b7ba0f11a574487234c5774e6852543aa99e6f0583f1ad3fc29b1a5f6a1fe0b" => :yosemite
    sha256 "c43b05feeea4b221e0de1fa9b48d760315013d20f8d73d47bb6ba8e66ffa3ecd" => :mavericks
  end

  fails_with :clang do
    build 600
    cause "error: 'ext/algorithm' file not found"
  end

  needs :cxx11
  needs :openmp

  def install
    system "make", "CC=#{ENV.cxx}",
      OS.mac? ? "-fmakefile_mac" : "-fmakefile"
    bin.install "bin/kmc", "bin/kmc_dump"
    doc.install "README.md", "readme.txt"
  end

  test do
    system "#{bin}/kmc"
  end
end
