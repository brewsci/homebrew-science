require "formula"

class Edirect < Formula
  homepage "http://www.ncbi.nlm.nih.gov/books/NBK179288/"
  #tag "bioinformatics"
  url "ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/edirect.tar.gz"
  sha1 "7f30f659f58c4bb77b87e514042fd415d226fc9a"
  version "2.00"

  def install
    doc.install "README"
    libexec.install "setup.sh", "setup-deps.pl"
    bin.install Dir["*"]
  end

  test do
    system "#{bin}/esearch -version"
  end
end
