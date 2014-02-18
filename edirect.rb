require "formula"

class Edirect < Formula
  homepage "http://www.ncbi.nlm.nih.gov/books/NBK179288/"
  url "ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/edirect.tar.gz"
  sha1 "a4c10f193adaaad72382983122a32f0521654991"
  version "1.00"

  def install
    doc.install "README"
    bin.install Dir['*']
  end

  test do
    system "#{bin}/esearch -version"
  end
end
