class Unicycler < Formula
  desc "Hybrid assembly pipeline for bacterial genomes"
  homepage "https://github.com/rrwick/Unicycler"
  url "https://github.com/rrwick/Unicycler/archive/v0.4.0.tar.gz"
  sha256 "0f2600a56c6e5fc26fff8611cd3dbebab57ecbe92978452b70b3cc40631b4139"
  head "https://github.com/rrwick/Unicycler/releases"
  # doi "10.1371/journal.pcbi.1005595"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "ef696a869d7854fbafff01aef5349c57c13af7e9a894655edc30646aaa4b6eba" => :sierra
    sha256 "874707af9ea2b7aab0a5744c2a47e30d6fe721833adc1f0054d3b25f345f3ce5" => :el_capitan
    sha256 "7ef48ceb95c5eeae9b2078b85a7299cddd43977735f5d07b65199615c0b7df6a" => :yosemite
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
