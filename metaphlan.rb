class Metaphlan < Formula
  desc "MetaPhlAn: Metagenomic Phylogenetic Analysis"
  homepage "https://huttenhower.sph.harvard.edu/metaphlan"
  # doi "10.1038/nmeth.2066"
  # tag "bioinformatics"

  url "https://bitbucket.org/nsegata/metaphlan/get/default.tar.bz2"
  version "1.7.8"
  sha256 "7113e00d2fe3aa1a8dcfce954a0b7ffd6ca9d726f5b3636b9f1d66a9c9254108"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "367be56e6f11c499f71d7909b505ab354a613becef234ecdb742cbafac71dc01" => :el_capitan
    sha256 "9e94fee8cdfdca6f792c619bde1862dc9be1110b4de23a4b48c050754b244c81" => :yosemite
    sha256 "61700d72a0a55c28e1471580eb2f12640fdc6b7f6c39454355dc9d0201d793f7" => :mavericks
  end

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
