require 'formula'

class Prank < Formula
  homepage 'http://code.google.com/p/prank-msa/'
  url 'http://prank-msa.googlecode.com/files/prank.src.121218.tgz'
  sha1 'bda3f1a8a696e8908bca2e6621dc5fa77dd9bfbc'
  head 'https://code.google.com/p/prank-msa/', :using => :git

  depends_on 'mafft'
  depends_on 'exonerate'

  def install
    cd "src" do
        system "make"
        bin.install "prank"
        man1.install "prank.1"
    end
  end

  def test
      system "#{bin}/prank -help"
  end
end
