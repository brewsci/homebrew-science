require "formula"

class Recon < Formula
  homepage "http://selab.janelia.org/recon.html"
  url "http://selab.janelia.org/software/recon/RECON1.05.tar.gz"
  sha1 "9fe7a830f72f013357e08091b22a259ed07518a8"

  def install
    inreplace "scripts/recon.pl", '$path = "";', "$path = \"#{bin}\";"
    bin.mkdir
    system *%W[make -C src]
    system *%W[make -C src install BINDIR=#{bin} MANDIR=#{man}]
    bin.install Dir["scripts/*"]
    doc.install %W[00README COPYRIGHT INSTALL LICENSE]
  end

  test do
    system "#{bin}/recon.pl 2>&1 |grep -q recon"
  end
end
