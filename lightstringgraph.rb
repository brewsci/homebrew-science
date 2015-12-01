class Lightstringgraph < Formula
  homepage "http://lsg.algolab.eu/"
  # http://arxiv.org/pdf/1405.7520.pdf
  head "https://github.com/AlgoLab/LightStringGraph.git"
  url "https://github.com/AlgoLab/LightStringGraph/archive/v0.1.0.tar.gz"
  sha256 "79385a648b2fa34759cc031197c41a709539c655a204889d0e9dddacf0058a3d"

  depends_on "beetl" => :recommended

  fails_with :clang do
    build 503
    cause "error: variable length array of non-POD element type 'string'"
  end

  def install
    system "make"
    bin.install Dir["bin/*"]
    doc.install %w[COPYING README.md]
    prefix.install "script"
  end

  test do
    system "#{bin}/lsg 2>&1 |grep lsg"
  end
end
