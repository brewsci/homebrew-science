require "formula"

class Edirect < Formula
  homepage "http://www.ncbi.nlm.nih.gov/books/NBK179288/"
  #tag "bioinformatics"
  url "ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/edirect.tar.gz"
  sha1 "95d542fb19a49e02bb41ac4c5cbf2cb32b17ff5a"
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
