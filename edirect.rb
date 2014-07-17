require "formula"

class Edirect < Formula
  homepage "http://www.ncbi.nlm.nih.gov/books/NBK179288/"
  url "ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/edirect.tar.gz"
  sha1 "e79de85075be9e9eab11dca49001863ccdec2cd3"
  version "1.80"

  def install
    doc.install "README"
    bin.install Dir["*"]
  end

  test do
    system "#{bin}/esearch -version"
  end
end
