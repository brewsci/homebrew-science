class Newicktools < Formula
  desc "Tools for the Newick tree format"
  homepage "https://github.com/lindenb/newicktools"
  # tag "bioinformatics"

  url "https://github.com/lindenb/newicktools/archive/v0.1.tar.gz"
  sha256 "3484d71ceaf9f8514de8d8c3d3b550c46cbb23514dcbd02f6e61ed151e8ebe90"
  head "https://github.com/lindenb/newicktools.git"

  bottle do
    cellar :any
    sha256 "eabc593d7a86d921e5a30b12dd3a77bca324bf17b330845ca02f3437247a5722" => :yosemite
    sha256 "db56c0f4b53676560efa180b40d0de985c4698a79fc6a75b02a631bbf3e27a08" => :mavericks
    sha256 "be6886dfb589ee2f9c72580ef4c5e150aebc38daf7f3ca7c5d17c73e40aa901d" => :mountain_lion
    sha256 "097f3a467f0062f2bf151a16c683f87b12be9144d080a2e4bbc1de5dd228e26f" => :x86_64_linux
  end

  depends_on "flex" unless OS.mac?
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
