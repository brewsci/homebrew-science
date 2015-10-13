class Metaphlan < Formula
  desc "MetaPhlAn: Metagenomic Phylogenetic Analysis"
  homepage "http://huttenhower.sph.harvard.edu/metaphlan"
  # doi "10.1038/nmeth.2066"
  # tag "bioinformatics"

  url "https://bitbucket.org/nsegata/metaphlan/get/default.tar.bz2"
  version "1.7.8"
  sha256 "077fa62a8a365c4b55ed3c3357f576704359f559b07eb1a179b3bd0feb8168da"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "blast" => :optional
  depends_on "bowtie2" => :recommended

  def install
    prefix.install Dir["*"]
    bin.install_symlink "../metaphlan.py"
    bin.install_symlink "../metaphlan.py" => "metaphlan"
  end

  test do
    system "#{bin}/metaphlan", "--version"
  end
end
