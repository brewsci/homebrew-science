class Sambamba < Formula
  desc "Tools for working with SAM/BAM data"
  homepage "https://lomereiter.github.io/sambamba"
  # doi "10.1093/bioinformatics/btv098"
  # tag "bioinformatics"

  url "https://github.com/lomereiter/sambamba.git", :tag => "v0.5.6", :revision => "9d761c5d69cfbcd53ceb4cca25b5a6f694ea09ac"
  head "https://github.com/lomereiter/sambamba.git"

  bottle do
    sha256 "400bee1dc9a5d0c571fc5b1a4a2479ec50ffb929af27a237f8a1225314a49272" => :yosemite
    sha256 "249b5a66154fbc96b34e9bf869abeaa35a96e862f50a8f0aa48f9c59c1350889" => :mavericks
    sha256 "169955f15b3bbb01f90696aec59f0c671df484ca92122b8eae1106e84e216fca" => :mountain_lion
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
      system "#{bin}/sambamba", "sort", "-t2", "-n", "ex1_header.bam", "-o", "ex1_header.nsorted.bam", "-m", "200K"
      assert File.exist?("ex1_header.nsorted.bam")
    end
  end
end
