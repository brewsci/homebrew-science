class Newicktools < Formula
  homepage "https://github.com/lindenb/newicktools"
  #tag "bioinformatics"

  url "https://github.com/lindenb/newicktools/archive/v0.1.tar.gz"
  sha1 "debdb6a8182ff3716fd991e8cf3a5d7dfbee5262"
  head "https://github.com/lindenb/newicktools.git"

  depends_on "graphviz" => :optional

  def install
    ENV.deparallelize

    # Fix dot: command not found
    inreplace "Makefile", " | dot -Tpng -otest01.png", ""

    system "make"
    system "make", "test"
    bin.install "newick2json", "newick2dot", "taxonomy2newick"
    doc.install "README.md"
  end

  test do
    system "#{bin}/taxonomy2newick", "-v"
  end
end
