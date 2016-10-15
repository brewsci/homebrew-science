class Lightstringgraph < Formula
  desc "Lightweight string graph construction"
  homepage "http://lsg.algolab.eu/"
  bottle do
    cellar :any
    sha256 "75fc42a4825b1ab2e49cdc7ac2b811ce703b4e563e4d12e2f42492913b22a607" => :sierra
    sha256 "3a8f5158f3f9e5ff44dddd3a13ac331d0b2c8824a960a6700ba882104963e1e0" => :el_capitan
    sha256 "1478fddf3f079339169d24759b9331af18837073b5b3dbafd2b86912df69b1ed" => :yosemite
  end

  # http://arxiv.org/pdf/1405.7520.pdf
  url "https://github.com/AlgoLab/LightStringGraph/archive/v0.4.0.tar.gz"
  sha256 "7a1530b147269b285875687fecaecbfd4d94c3db04d33ddeb1d0624547317b00"
  head "https://github.com/AlgoLab/LightStringGraph.git"
  revision 1

  depends_on "boost"
  depends_on "beetl" => :recommended

  fails_with :clang do
    cause "error: variable length array of non-POD element type 'string'"
  end

  def install
    system "make", "all"
    bin.install Dir["bin/*"]
    doc.install %w[COPYING README.md]
  end

  test do
    system "#{bin}/lsg 2>&1 |grep lsg"
  end
end
