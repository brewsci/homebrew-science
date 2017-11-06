class Quicktree < Formula
  desc "Phylogenetic neighbor-joining tree builder"
  homepage "https://www.sanger.ac.uk/resources/software/quicktree/"

  url "https://github.com/khowe/quicktree/archive/v2.2.tar.gz"
  sha256 "e44d9147a81888d6bfed5e538367ecd4e5d373ae882d5eb9649e5e33f54f1bd6"

  head "https://github.com/khowe/quicktree.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "148eec40495d7978b6b4b507ece131aeaa7b2325d02ccce63844365e009b1d0b" => :high_sierra
    sha256 "3c41d2a3de9cc96ca5732c0c323f66da142ff828170de80a3867795282fc0a38" => :sierra
    sha256 "9aaa5691ece1f0c7ebabe00a2f725922a81f61696dc6b7ee03957207b17b09d4" => :el_capitan
    sha256 "4d60f4c3597fa15761e109296fb77daed8dc2a7361b3ef01e83a161ba251ae4e" => :x86_64_linux
  end

  def install
    system "make"
    bin.install "quicktree"
    doc.install "LICENSE", "README.md"
  end

  test do
    assert_match "UPGMA", shell_output("#{bin}/quicktree -h 2>&1")
    assert_match version.to_s, shell_output("#{bin}/quicktree -v 2>&1")
  end
end
