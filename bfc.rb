class Bfc < Formula
  homepage "https://github.com/lh3/bfc"
  # doi "10.1093/bioinformatics/btv290"
  # tag "bioinformatics"

  url "https://github.com/lh3/bfc/archive/submitted-v1.tar.gz"
  version "175"
  sha256 "0fad5807a417f8cc033b5deea04c0fa763947e55415372f89bd2914df48154b7"
  head "https://github.com/lh3/bfc.git"

  bottle do
    cellar :any
    sha256 "4da661a1190e514638bb6d38fb83b54970ff3995d79e868fb9392e644fdb2b1d" => :yosemite
    sha256 "595fb5c808860401c561628103f34d2c7338884dfa9c99a232fb222936e5e8ea" => :mavericks
    sha256 "d04cf428537c4b351c4c91e500f1b1e446d0c5359fae6e61ef2bbbbcaed2771e" => :mountain_lion
  end

  def install
    system "make"
    bin.install "bfc", "hash2cnt"
    doc.install "README.md"
  end

  test do
    system "#{bin}/bfc", "-v"
  end
end
