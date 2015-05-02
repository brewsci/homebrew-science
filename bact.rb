class Bact < Formula
  homepage "http://chasen.org/~taku/software/bact/"
  url "http://chasen.org/~taku/software/bact/bact-0.13.tar.gz"
  sha256 "4aa55c30621afd3793bd15471b3c0d77d3b489051cbfb30a9f0640de8928ab40"

  def install
    system "make"
    system "make", "test"
    bin.install "bact_learn", "bact_classify", "bact_mkmodel"
    doc.install "README", "AUTHORS", "COPYING", "index.html", "bact.css"
    (share/"bact").install Dir["jp*"], Dir["med.*"]
  end
end
