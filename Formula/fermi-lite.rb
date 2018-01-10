class FermiLite < Formula
  desc "Assembling Illumina short reads in small regions"
  homepage "https://github.com/lh3/fermi-lite"
  bottle do
    cellar :any_skip_relocation
    sha256 "f0534f7ce0bb08aecef23880a4a3483a3ec816534ce3366ed979dda8b912a761" => :sierra
    sha256 "49038f2b53b55d0ca1fe6b6685517f23140e805ab7542be99302d46554bdabe7" => :el_capitan
    sha256 "1e7b55c67e73f4bea13226b0af2e188cdc87a6b9670e9ec1bc4ffcedba1a6e7b" => :yosemite
    sha256 "454206663fb19cb4d1909a39c70ec417a98754ce291c17d98f6d6d8e109b5df9" => :x86_64_linux
  end

  # doi "10.1093/bioinformatics/bts280"
  # tag "bioinformatics"

  url "https://github.com/lh3/fermi-lite/archive/v0.1.tar.gz"
  sha256 "661053bc7213b575912fc7be9cdfebc1c92a10319594a8e8f18542c9e2adda6e"
  head "https://github.com/lh3/fermi-lite.git"

  def install
    system "make"
    prefix.install "README.md", "LICENSE.txt"
    bin.install "fml-asm"
    lib.install "libfml.a"
    include.install "fml.h"
  end

  test do
    system "#{bin}/fml-asm 2>&1 |grep -q heterozygotes"
  end
end
