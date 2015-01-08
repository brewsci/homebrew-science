class Newicktools < Formula
  homepage "https://github.com/lindenb/newicktools"
  #tag "bioinformatics"

  url "https://github.com/lindenb/newicktools/archive/v0.1.tar.gz"
  sha1 "debdb6a8182ff3716fd991e8cf3a5d7dfbee5262"
  head "https://github.com/lindenb/newicktools.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "4793277d4f2db8807184a1574f7dc908319cb758" => :yosemite
    sha1 "909db193225821b2294e6650961e73b78fb496ac" => :mavericks
    sha1 "b5b26082e106eee6ff7ef43adef5b0a36e5e10d4" => :mountain_lion
  end

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
