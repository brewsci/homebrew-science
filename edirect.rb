require "formula"

class Edirect < Formula
  homepage "http://www.ncbi.nlm.nih.gov/books/NBK179288/"
  url "ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/edirect.tar.gz"
  sha1 "e82cfc00c8e20208b2918dff090f6b4ce218491d"
  version "1.90"

  def install
    doc.install "README"
    bin.install Dir["*"]
  end

  test do
    system "#{bin}/esearch -version"
  end
end
