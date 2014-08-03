require 'formula'

class Prank < Formula
  homepage 'http://code.google.com/p/prank-msa/'
  url 'https://prank-msa.googlecode.com/files/prank.src.130410.tgz'
  sha1 '8bfaec6e9bed1b0276188752609e753088e28acf'

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

  test do
    system "#{bin}/prank", "-help"
  end
end
