class FermiLite < Formula
  desc "Assembling Illumina short reads in small regions"
  homepage "https://github.com/lh3/fermi-lite"
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
