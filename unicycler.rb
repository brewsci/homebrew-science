class Unicycler < Formula
  desc "Hybrid assembly pipeline for bacterial genomes"
  homepage "https://github.com/rrwick/Unicycler"
  url "https://github.com/rrwick/Unicycler/archive/v0.4.2.tar.gz"
  sha256 "58dbeee3b829e00a6f53ea0a151fd6dc77f1a7c35fefa31602deb2f1f5f481ea"
  head "https://github.com/rrwick/Unicycler/releases"
  # doi "10.1371/journal.pcbi.1005595"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "a3581a5d5614fc13b8808714d0f2138d71bf5fd99df465a52086866199254193" => :high_sierra
    sha256 "f616d163f311791d7bd0e13236a7ecfe737f1b929eff636112b37f27173b525e" => :sierra
    sha256 "892d19b781e255e91ca48f89394fafb0ed2f6bc8224206a67c9864fa728c0504" => :el_capitan
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
