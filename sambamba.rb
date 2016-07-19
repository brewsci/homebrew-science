class Sambamba < Formula
  desc "Tools for working with SAM/BAM data"
  homepage "https://lomereiter.github.io/sambamba"
  url "https://github.com/lomereiter/sambamba.git",
    :tag => "v0.6.3",
    :revision => "4258ccbfeac21c9ef88c394f1145bf655dba8020"
  head "https://github.com/lomereiter/sambamba.git"
  # doi "10.1093/bioinformatics/btv098"
  # tag "bioinformatics"

  bottle do
    sha256 "a1be7e5983f6ecc20dfde24f321692bc1149e9b87c15f6af9924072cd9029c08" => :el_capitan
    sha256 "410602e7eb4adb9c96e61449a2967ce3eda88aad6136add0bc38d4ad9769b29d" => :yosemite
    sha256 "62f775aaabeeed8957a6c9fccadce41af6f8a1e37957d17da7fa7d7036e83ce7" => :mavericks
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
