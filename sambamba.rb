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
    revision 1
    sha256 "5aa219d9f4cbd0d0568250f2ff3e196129069efe4e9e3da5429638a094167250" => :yosemite
    sha256 "83a4920a1a3f9b867437a806158384de57dea6f565f427bed49c37cca6988a7f" => :mavericks
    sha256 "390278b35a4c5cb30f9728566d0c9cfe57a1e05f40f527b4e5d0a7e53b22ab3c" => :mountain_lion
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
