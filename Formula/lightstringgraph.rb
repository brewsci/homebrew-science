class Lightstringgraph < Formula
  desc "Lightweight string graph construction"
  homepage "http://lsg.algolab.eu/"
  # https://arxiv.org/pdf/1405.7520.pdf
  url "https://github.com/AlgoLab/LightStringGraph/archive/v0.4.0.tar.gz"
  sha256 "7a1530b147269b285875687fecaecbfd4d94c3db04d33ddeb1d0624547317b00"
  revision 4
  head "https://github.com/AlgoLab/LightStringGraph.git"

  bottle :disable, "needs to be rebuilt with latest boost"

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
