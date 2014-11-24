require "formula"

class Htsbox < Formula
  homepage "https://github.com/lh3/htsbox"
  head "https://github.com/lh3/htsbox.git"
  #tag "bioinformatics"

  version "r266"
  url "https://github.com/lh3/htsbox/archive/1559856bb799c88a4c9cf5b01a4cfd8846fb05d7.tar.gz"
  sha1 "d7c4d1608eced7823fcab8b6e65bc87f2deab4f2"

  depends_on "htslib"

  def install
    system "make"
    bin.install "htsbox"
    doc.install "README.md"
  end

  test do
    system "#{bin}/htsbox 2>&1 |grep htsbox"
  end
end
