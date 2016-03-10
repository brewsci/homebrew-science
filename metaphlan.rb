class Metaphlan < Formula
  desc "MetaPhlAn: Metagenomic Phylogenetic Analysis"
  homepage "http://huttenhower.sph.harvard.edu/metaphlan"
  # doi "10.1038/nmeth.2066"
  # tag "bioinformatics"

  url "https://bitbucket.org/nsegata/metaphlan/get/default.tar.bz2"
  version "1.7.8"
  sha256 "7113e00d2fe3aa1a8dcfce954a0b7ffd6ca9d726f5b3636b9f1d66a9c9254108"

  bottle do
    cellar :any_skip_relocation
    sha256 "811b8f8f9678f84f3ca0bd635ee4eaaa959fcaea47fd1333432e19f259b3bd7f" => :el_capitan
    sha256 "a66d438096573c59c87762428adcbb389f5050f3502448f2b96a675785530deb" => :yosemite
    sha256 "4cfbdf81498a748abb78769726b9de8140a984a79f41fc4d9cbcdb120d72663b" => :mavericks
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
