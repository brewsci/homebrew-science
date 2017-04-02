class Kmc < Formula
  desc "Fast and frugal disk based k-mer counter"
  homepage "http://sun.aei.polsl.pl/kmc/"
  # doi "10.1093/bioinformatics/btv022"
  # tag "bioinformatics"

  url "https://github.com/marekkokot/KMC/archive/v3.0.1.tar.gz"
  sha256 "0dbc9254f95541a060d94076d2aa03bb57eb2da114895848f65af0db1e4f8b67"

  head "https://github.com/marekkokot/KMC.git"

  bottle do
    sha256 "95d5fed8eeaca93180909abd67bd0ee6306aad77795884114ac948fe0292adb0" => :sierra
    sha256 "cb509c126499a5b3156131042472688faafba4499246940d3ca270340b659572" => :el_capitan
    sha256 "de1beeb4921a7a75b316dd2b100346ed396dfe765a72b114027dbfd231c1a9f5" => :yosemite
    sha256 "1a060f43cfad928c66b84358b05f4edafdd7697366402d6ea376e6ff7e9f4eae" => :x86_64_linux
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
