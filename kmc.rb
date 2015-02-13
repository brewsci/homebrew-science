class Kmc < Formula
  homepage "http://sun.aei.polsl.pl/kmc/"
  # doi "arXiv:1407.1507"
  # tag "bioinformatics"

  url "https://github.com/marekkokot/KMC/archive/eb982b35ca51fdd44a98b21ee540e5d18f4ea1ed.tar.gz"
  sha1 "326e680f0504ce8f50b1739f4f5d12584457fe19"
  version "2.1.1"

  head "https://github.com/marekkokot/KMC.git"

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
