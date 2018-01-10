class Grabix < Formula
  desc "Tool for random access into BGZF files"
  homepage "https://github.com/arq5x/grabix"
  # tag "bioinformatics"
  url "https://github.com/arq5x/grabix/archive/0.1.6.tar.gz"
  sha256 "a1c92311501f583ad1912b6e0394f95d06b8e3aafe1db6a7ba517d5aed161043"
  head "https://github.com/arq5x/grabix.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "25b161ba3f364c3d92d5b6ffa116e4ea6ee11bff9a6778394ae00b6e33b26b46" => :yosemite
    sha256 "ba46405a755b4bca6d0819315c674b6b955f7f968a9e9ef64b2b8cacb24d537a" => :mavericks
    sha256 "c64ddc603685144a212d5a9034f5e012035e9e133191a5b5fda4443fd36ade58" => :mountain_lion
    sha256 "3b66be2f5fec289232cd4fdd7beef197c1d67f8e48b9cf4cf1d4fd5adaadfd40" => :x86_64_linux
  end

  def install
    system "make"
    bin.install "grabix"
    doc.install "README.md"
    pkgshare.install "simrep.chr1.bed"
  end

  test do
    assert_equal `#{bin}/grabix check #{pkgshare}/simrep.chr1.bed`.chomp, "no"
  end
end
