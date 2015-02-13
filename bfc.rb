class Bfc < Formula
  homepage "https://github.com/lh3/bfc"
  # doi "arXiv:1502.03744"
  # tag "bioinformatics"

  url "https://github.com/lh3/bfc/archive/submitted-v1.tar.gz"
  version "175"
  sha1 "50fdbf2751c1fb94e6ef660774f93be1d3a13ae3"
  head "https://github.com/lh3/bfc.git"

  def install
    system "make"
    bin.install "bfc", "hash2cnt"
    doc.install "README.md"
  end

  test do
    system "#{bin}/bfc", "-v"
  end
end
