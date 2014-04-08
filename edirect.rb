require "formula"

class Edirect < Formula
  homepage "http://www.ncbi.nlm.nih.gov/books/NBK179288/"
  url "ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/edirect.tar.gz"
  sha1 "73d84da151149443bbb69174d763a78ed642e0df"
  version "1.60"

  def install
    doc.install "README"
    bin.install Dir['*']
  end

  test do
    system "#{bin}/esearch -version"
  end
end
