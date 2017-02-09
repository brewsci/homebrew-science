class Kmc < Formula
  desc "Fast and frugal disk based k-mer counter"
  homepage "http://sun.aei.polsl.pl/kmc/"
  # doi "10.1093/bioinformatics/btv022"
  # tag "bioinformatics"

  url "https://github.com/marekkokot/KMC/archive/v3.0.1.tar.gz"
  sha256 "0dbc9254f95541a060d94076d2aa03bb57eb2da114895848f65af0db1e4f8b67"

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

  needs :cxx14
  needs :openmp

  def install
    system "make", "CC=#{ENV.cxx}", "KMC_BIN_DIR=#{bin}",
      OS.mac? ? "-fmakefile_mac" : "-fmakefile"
  end

  test do
    system "#{bin}/kmc"
  end
end
