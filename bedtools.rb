require "formula"

class Bedtools < Formula
  homepage "https://github.com/arq5x/bedtools2"
  #doi "10.1093/bioinformatics/btq033"
  #tag "bioinformatics"
  url "https://github.com/arq5x/bedtools2/releases/download/v2.22.0/bedtools-2.22.0.tar.gz"
  sha1 "96f9f7031806de5d4ec694aeb9db31c3f8188f9b"
  head "https://github.com/arq5x/bedtools2.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    revision 1
    sha1 "5894c0bac14ffe388c9631281d28890cef87dd8b" => :yosemite
    sha1 "65ed7b9e36eb1c7ab7d6849443d4460b22d4a29a" => :mavericks
    sha1 "ad78698455a11a2f86da73527f809549ce5366db" => :mountain_lion
  end

  def install
    system "make"
    prefix.install "bin"
    doc.install %w[README.md RELEASE_HISTORY]
  end

  test do
    system "#{bin}/bedtools", "--version"
  end
end
