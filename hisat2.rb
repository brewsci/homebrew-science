class Hisat2 < Formula
  desc "graph-based alignment to a population of genomes"
  homepage "https://ccb.jhu.edu/software/hisat2/"
  url "ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/hisat2-2.0.5-source.zip"
  sha256 "ef74e2ab828aff8fd8a6320feacc8ddb030b58ecbc81c095609acb3851b6dc53"
  # tag "bioinformatics"
  # doi "10.1038/nmeth.3317"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd3713455f92812d02e6285cb0fc2bf23faaea1834cb8f67678603a6e4d800ea" => :sierra
    sha256 "39313553a9dc3313a5115193d85ad177feb1d4a9540b4021ccbf47db5d159565" => :el_capitan
    sha256 "a89563bef8fc8d785b8d93b409c3b5ed44c4e6010f35868bdb4d8c893002c2b2" => :yosemite
    sha256 "002d05148a3df74e97cbbe762d5f27607cb1e9ebbb7932fcc9cd1932574d6d13" => :x86_64_linux
  end

  def install
    system "make"
    bin.install "hisat2", Dir["hisat2-*"]
    doc.install Dir["doc/*"]
  end

  test do
    assert_match "HISAT2", shell_output("#{bin}/hisat2 2>&1", 1)
  end
end
