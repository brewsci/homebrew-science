class Sambamba < Formula
  desc "Tools for working with SAM/BAM data"
  homepage "https://lomereiter.github.io/sambamba"
  # doi "10.1093/bioinformatics/btv098"
  # tag "bioinformatics"

  url "https://github.com/lomereiter/sambamba.git", :tag => "v0.5.6", :revision => "9d761c5d69cfbcd53ceb4cca25b5a6f694ea09ac"
  head "https://github.com/lomereiter/sambamba.git"

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
    cd pkgshare do
      system *%W[#{bin}/sambamba sort -t2 -n ex1_header.bam -o ex1_header.nsorted.bam -m 200K]
      assert File.exist?("ex1_header.nsorted.bam")
    end
  end
end
