class Sambamba < Formula
  desc "Tools for working with SAM/BAM data"
  homepage "https://lomereiter.github.io/sambamba"
  url "https://github.com/lomereiter/sambamba.git",
    tag: "v0.6.4",
    revision: "24720b5e5b9a9d31219eddc6abaaabaf7cffdfc8"
  head "https://github.com/lomereiter/sambamba.git"
  # doi "10.1093/bioinformatics/btv098"
  # tag "bioinformatics"

  bottle do
    sha256 "7b44b4f06b0cc6cfdbfb0b6cb099ed32780767cc02e4a4ea3b90aa22b9812a28" => :el_capitan
    sha256 "a1fadb84af7e1a73daede860b45d8adfd2f6785d227e1f41d8960ab7d6d34883" => :yosemite
    sha256 "57171cb36e80bf605e54bd2142aa5edf0f0fadc7b83c52043ea51731839888c7" => :mavericks
  end

  depends_on "ldc" => :build

  def install
    ENV.deparallelize
    system "make", "sambamba-ldmd2-64"
    bin.install "build/sambamba"
    doc.install "README.md"
    pkgshare.install "BioD/test/data/ex1_header.bam"
  end

  test do
    system *%W[#{bin}/sambamba sort -t2 -n #{pkgshare}/ex1_header.bam -o ex1_header.nsorted.bam -m 200K]
    assert File.exist?("ex1_header.nsorted.bam")
  end
end
