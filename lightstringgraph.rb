class Lightstringgraph < Formula
  desc "Lightweight string graph construction"
  homepage "http://lsg.algolab.eu/"
  bottle do
    cellar :any
    sha256 "3250f00f03aaba15e453633d6e86951bd4caaf7fd6bf9861d703e195f23c494f" => :sierra
    sha256 "9d4e826dbfeffdb135b66b8b1efb58b1493ca57ba2355dec80b078d0bfc3ef17" => :el_capitan
    sha256 "39337dd9526d34d3cbe0e0db7a6eae0911ad6ae0c600b51dce9513aa2bc03cef" => :yosemite
  end

  # http://arxiv.org/pdf/1405.7520.pdf
  url "https://github.com/AlgoLab/LightStringGraph/archive/v0.4.0.tar.gz"
  sha256 "7a1530b147269b285875687fecaecbfd4d94c3db04d33ddeb1d0624547317b00"
  head "https://github.com/AlgoLab/LightStringGraph.git"
  revision 2

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
