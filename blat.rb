require 'formula'

class Blat < Formula
  homepage 'http://genome.ucsc.edu/FAQ/FAQblat.html'
  url 'http://users.soe.ucsc.edu/~kent/src/blatSrc35.zip'
  sha1 'a2cae7407e512166bf7b1ed300db9be6649693bd'

  def install
    bin.mkpath
    system "make", "MACHTYPE=darwin", "BINDIR=#{bin}"
  end

  def test
    system "#{bin}/blat"
  end
end
