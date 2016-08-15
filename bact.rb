class Bact < Formula
  desc "Machine learning tool for labeled orderd trees"
  homepage "http://chasen.org/~taku/software/bact/"
  url "http://chasen.org/~taku/software/bact/bact-0.13.tar.gz"
  sha256 "4aa55c30621afd3793bd15471b3c0d77d3b489051cbfb30a9f0640de8928ab40"

  bottle do
    cellar :any
    sha256 "8de8fd7cda5405a06d39eacd2615ee3629aeb87952f54539d795e273b1acdfe8" => :yosemite
    sha256 "c778234069cb91598fcf7589cdfd8349bfbc09006087d4400491d1261a1c89b8" => :mavericks
    sha256 "70944f64bdf141a1f084e612e0e816785f89e07d8de5b1a1bc2d3d1c1b0b6708" => :mountain_lion
  end

  def install
    system "make"
    system "make", "test"
    bin.install "bact_learn", "bact_classify", "bact_mkmodel"
    doc.install "README", "AUTHORS", "COPYING", "index.html", "bact.css"
    pkgshare.install Dir["jp*"], Dir["med.*"]
  end

  test do
    system "bact_learn", "#{pkgshare}/jp.test", "./jp.model"
  end
end
