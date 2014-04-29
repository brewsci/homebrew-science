require "formula"

class Edirect < Formula
  homepage "http://www.ncbi.nlm.nih.gov/books/NBK179288/"
  url "ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/edirect.tar.gz"
  sha1 "765f1ce83bca933d74103867822210104a76406c"
  version "1.70"

  def install
    doc.install "README"
    bin.install Dir["*"]
  end

  test do
    system "#{bin}/esearch -version"
  end
end
