require 'formula'

class Meme < Formula
  homepage 'http://meme.nbcr.net/meme/'
  url 'http://ebi.edu.au/ftp/software/MEME/4.9.0/meme_4.9.0_4.tar.gz'
  sha1 '1419ca428ce7b0053cf3d67b99ffff97e5985d39'
  version '4.9.0-p4'

  keg_only <<-EOF.undent
    MEME installs many commands, and some conflict
    with other packages.
  EOF

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/meme", "#{bin}/../doc/lipo.fasta"
  end
end
