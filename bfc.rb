class Bfc < Formula
  desc "High-performance error correction for Illumina resequencing data"
  homepage "https://github.com/lh3/bfc"
  # doi "10.1093/bioinformatics/btv290"
  # tag "bioinformatics"

  url "https://github.com/lh3/bfc/archive/69ab176e7aac4af482d7d8587e45bfe239d02c96.tar.gz"
  version "181"
  sha256 "4f510557ea5fb9ed179bc21d9ffc85c0ae346525b56e3b72bf6204d64f6bfb8b"
  head "https://github.com/lh3/bfc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5605112db4ca0171ea78216c6d1c6c31b4b564d2c92fb5710b4a6f6636b0c4d" => :el_capitan
    sha256 "2c8ecab3ec5599d307e85155f56b3cdcb7b10ad1e3d29c38e40cb67744eb71d8" => :yosemite
    sha256 "c00cf990eb917d21968e472e3f6231308462e1858dbac7725439d230907067d3" => :mavericks
    sha256 "129025d0d4638d5104f9ed1f806875e24e53d8a1c64b5b8a6bdd8dda2e917b1c" => :x86_64_linux
  end

  def install
    system "make"
    bin.install "bfc", "hash2cnt"
    doc.install "README.md"
  end

  test do
    system "#{bin}/bfc", "-v"
  end
end
