class Recon < Formula
  homepage "http://www.repeatmasker.org/RepeatModeler.html"
  # doi "10.1101/gr.88502"
  # tag "bioinformatics"
  url "http://www.repeatmasker.org/RepeatModeler/RECON-1.08.tar.gz"
  sha256 "699765fa49d18dbfac9f7a82ecd054464b468cb7521abe9c2bd8caccf08ee7d8"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any_skip_relocation, high_sierra:  "cd1fe441ff386d786943598239ec0dd39a3806f156f469b30e4039314f42abab"
    sha256 cellar: :any_skip_relocation, sierra:       "9d28e681fdc14d5f10906a20e55c04d93384b6d73975ab06157d42c2a578f2ac"
    sha256 cellar: :any_skip_relocation, el_capitan:   "7a99aac95cb168f1fa13db23186fea687750d488cde5d869b98403d10b516248"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5be204c75319325a55dab73a9f63b495ec406afe646c03149b7c3ead9f9dd3d3"
  end

  def install
    inreplace "scripts/recon.pl", '$path = "";', "$path = \"#{bin}\";"
    bin.mkdir
    system(*%w[make -C src])
    system(*%W[make -C src install BINDIR=#{bin} MANDIR=#{man}])
    bin.install Dir["scripts/*"]
    doc.install %w[00README COPYRIGHT INSTALL LICENSE]
  end

  test do
    assert_match "usage", shell_output("#{bin}/recon.pl 2>&1", 255)
  end
end
