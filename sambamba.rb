class Sambamba < Formula
  desc "Tools for working with SAM/BAM data"
  homepage "https://lomereiter.github.io/sambamba"
  url "https://github.com/lomereiter/sambamba.git",
    :tag => "v0.6.5",
    :revision => "22fef748d96a8ee53e5b458e177dbc3457a7cbeb"
  head "https://github.com/lomereiter/sambamba.git"
  # doi "10.1093/bioinformatics/btv098"
  # tag "bioinformatics"

  bottle do
    sha256 "18d33a5ff6dad35ac79bc360f23623ccc910f28b41073e9e1dcd92538f454615" => :sierra
    sha256 "93eb5f7159b8c271985705abf7894dd4651bfa13063aca2f593a4518fdcdf101" => :el_capitan
    sha256 "1d69b9413a45c367c404393ce6ad4881382479c8dd14e3451744dd7fb0a9b666" => :yosemite
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
