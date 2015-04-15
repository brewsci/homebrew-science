class Sambamba < Formula
  homepage "https://lomereiter.github.io/sambamba"
  # doi "10.1093/bioinformatics/btv098"
  # tag "bioinformatics"

  url "https://github.com/lomereiter/sambamba.git", :tag => "v0.5.4", :revision => "66dd706d81e59fa70a36f030e47d9967fa3a46a8"
  head "https://github.com/lomereiter/sambamba.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "7808ae09115da280d9af4e1e90b6fc057694b6ba57f01c5878fce5f060d39d81" => :yosemite
    sha256 "4158109cf2555474458a0a91aa18308d72beeb4789eb8d1f2aa9b2a4386585ab" => :mavericks
    sha256 "b73d62e18346aee00e18b859ef6458814ff1fb5e3cee1593d772422c3bce731e" => :mountain_lion
  end

  depends_on "ldc" => :build

  def install
    ENV.deparallelize
    system "make", "sambamba-ldmd2-64"
    bin.install "build/sambamba"
    (libexec/"share").install "BioD/test/data/ex1_header.bam"
  end

  test do
    cd libexec/"share" do
      system "#{bin}/sambamba", "sort", "-t2", "-n", "ex1_header.bam", "-o", "ex1_header.nsorted.bam", "-m", "200K"
      assert File.exist?("ex1_header.nsorted.bam")
    end
  end
end
