require "formula"

class Recon < Formula
  homepage "http://www.repeatmasker.org/RepeatModeler.html"
  url "http://www.repeatmasker.org/RECON-1.07.tar.gz"
  sha1 "215ef7d47d41faf657bcb4ee211019ed713e399e"

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
