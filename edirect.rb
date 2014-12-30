class Edirect < Formula
  homepage "http://www.ncbi.nlm.nih.gov/books/NBK179288/"
  #tag "bioinformatics"

  url "ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/edirect.tar.gz"
  sha1 "45578de2ae034960dd65a9fc0fbcb81ffdb0898c"
  version "2.00"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "2db4443d1cf282114efd531e878d6a83c4c93b2d" => :yosemite
    sha1 "448f84d3ea4fa58bb5cc2bbd46510cdaab06e6fb" => :mavericks
    sha1 "a3cd5b4533dc11920729f2270e5497eddeeb66a1" => :mountain_lion
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
