class Quicktree < Formula
  desc "Phylogenetic neighbor-joining tree builder"
  homepage "https://www.sanger.ac.uk/resources/software/quicktree/"

  url "https://github.com/khowe/quicktree/archive/v2.2.tar.gz"
  sha256 "e44d9147a81888d6bfed5e538367ecd4e5d373ae882d5eb9649e5e33f54f1bd6"

  head "https://github.com/khowe/quicktree.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8222c84b13bf458277491486e8640e730a55d4ec783da259519257f3acb44fad" => :high_sierra
    sha256 "ccf2bef7031e048b6db14e166350c88eee40e0ea0307f99c2aa21e90ce141f85" => :sierra
    sha256 "063f94991fce68c6ffffcfc9ec15c94744039e2ebedd03ad15e9c0c74a5bc192" => :el_capitan
    sha256 "105ef0941e85b3bf1fdd939da409ed4c62c4a91e7be8762b79e7706ae9a18b1f" => :x86_64_linux
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
