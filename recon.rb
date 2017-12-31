class Recon < Formula
  homepage "http://www.repeatmasker.org/RepeatModeler.html"
  # doi "10.1101/gr.88502"
  # tag "bioinformatics"
  url "http://www.repeatmasker.org/RepeatModeler/RECON-1.08.tar.gz"
  sha256 "699765fa49d18dbfac9f7a82ecd054464b468cb7521abe9c2bd8caccf08ee7d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd1fe441ff386d786943598239ec0dd39a3806f156f469b30e4039314f42abab" => :high_sierra
    sha256 "9d28e681fdc14d5f10906a20e55c04d93384b6d73975ab06157d42c2a578f2ac" => :sierra
    sha256 "7a99aac95cb168f1fa13db23186fea687750d488cde5d869b98403d10b516248" => :el_capitan
    sha256 "5be204c75319325a55dab73a9f63b495ec406afe646c03149b7c3ead9f9dd3d3" => :x86_64_linux
  end

  def install
    inreplace "scripts/recon.pl", '$path = "";', "$path = \"#{bin}\";"
    bin.mkdir
    system *%W[make -C src]
    system *%W[make -C src install BINDIR=#{bin} MANDIR=#{man}]
    bin.install Dir["scripts/*"]
    doc.install %W[00README COPYRIGHT INSTALL LICENSE]
  end

  test do
    assert_match "usage", shell_output("#{bin}/recon.pl 2>&1", 255)
  end
end
