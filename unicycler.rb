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
    sha256 "ef696a869d7854fbafff01aef5349c57c13af7e9a894655edc30646aaa4b6eba" => :sierra
    sha256 "874707af9ea2b7aab0a5744c2a47e30d6fe721833adc1f0054d3b25f345f3ce5" => :el_capitan
    sha256 "7ef48ceb95c5eeae9b2078b85a7299cddd43977735f5d07b65199615c0b7df6a" => :yosemite
    sha256 "000887233d01f2b5d14d1d22cdb074867eee4afe625e32ad10a5c2c7ddec3d1a" => :x86_64_linux
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
