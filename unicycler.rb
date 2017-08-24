class Unicycler < Formula
  desc "Hybrid assembly pipeline for bacterial genomes"
  homepage "https://github.com/rrwick/Unicycler"
  url "https://github.com/rrwick/Unicycler/archive/v0.4.1.tar.gz"
  sha256 "00200ea13c2ce90ba7b55917060ffb2e425f59ba515423fa516ff3d6519af336"
  head "https://github.com/rrwick/Unicycler/releases"
  # doi "10.1371/journal.pcbi.1005595"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "84b4dbac901c6a9e1e1fd6153b3f3cbd6530d434b53206c926351223c4431525" => :sierra
    sha256 "5fd4d10e7ba577aec25d0f2984cea31b1f98eed6a49e4b21c77edaaea2a3e952" => :el_capitan
    sha256 "0a7d12716f60d234b8c4352c14bf3cd4895524fa9d6e4565f61e169dd7a3e91f" => :yosemite
  end

  needs :cxx14

  depends_on :python3
  depends_on "blast"
  depends_on "bowtie2"
  depends_on "pilon"
  depends_on "racon"
  depends_on "samtools"
  depends_on "spades"

  def install
    system "python3", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    assert_match "usage", shell_output("#{bin}/unicycler --help")
  end
end
