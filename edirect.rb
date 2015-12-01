class Edirect < Formula
  homepage "http://www.ncbi.nlm.nih.gov/books/NBK179288/"
  # tag "bioinformatics"

  url "ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/edirect.tar.gz"
  sha256 "694673fa248677eac4dcb67ed9cd748e5b0ea80fa07f563603b39469055e6e6a"
  version "2.00"

  bottle do
    cellar :any
    sha256 "2d76a8e877b4831455d52894d3854edec634928dd0559764abbe273036468d46" => :yosemite
    sha256 "a7e1426882b5e6ab09d2b87cc8d64a56c7fd268712b662016f8a43f64c650e4e" => :mavericks
    sha256 "c0714a55b8b9d629bee4c40717e48df563798fbda82235ba6ea3598c5380775f" => :mountain_lion
  end

  def install
    doc.install "README"
    libexec.install "setup.sh", "setup-deps.pl"
    bin.install Dir["*"]
  end

  test do
    system "#{bin}/esearch", "-version"
  end
end
