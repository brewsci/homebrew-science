class Quicktree < Formula
  desc "Phylogenetic neighbor-joining tree builder"
  homepage "https://www.sanger.ac.uk/resources/software/quicktree/"

  url "https://github.com/khowe/quicktree/archive/v2.0.tar.gz"
  sha256 "e47680b69d411602c2fd1bc166f1564ebfc64b49f7be5e083f7e03ed4f72f94e"

  head "https://github.com/khowe/quicktree.git"

  def install
    system "make"
    bin.install "quicktree"
  end

  test do
    assert_match "UPGMA", shell_output("#{bin}/quicktree -h 2>&1", 0)
  end
end
