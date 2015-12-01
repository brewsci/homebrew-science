class Kmc < Formula
  homepage "http://sun.aei.polsl.pl/kmc/"
  # doi "10.1093/bioinformatics/btv022"
  # tag "bioinformatics"

  url "https://github.com/marekkokot/KMC/archive/2.1.1.tar.gz"
  sha256 "7f8dba362a3827f8c8c87b3e29abd91de0ae23a1901cfc885783ce0e1502acce"

  head "https://github.com/marekkokot/KMC.git"

  bottle do
    sha256 "8e98b0fd8cf4350644dfb0e42e7060fbb114123972cb3544c1184dd67c1ee4c1" => :yosemite
    sha256 "5ef5c6c845fb245e816d8a64a6e1bc23d917c4e39192bea512fcbd106879049a" => :mavericks
    sha256 "2caba540c74441882decaf5117b1b072a0e3fb927cd16eb4ab29802746088334" => :mountain_lion
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
