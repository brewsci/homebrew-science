require "formula"

class Edirect < Formula
  homepage "http://www.ncbi.nlm.nih.gov/books/NBK179288/"
  url "ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/edirect.tar.gz"
  sha1 "8b9ae110c93f4a2eddc84bd510c1dcbf371388f3"
  version "1.70"

  def install
    doc.install "README"
    bin.install Dir["*"]
  end

  test do
    system "#{bin}/esearch -version"
  end
end
