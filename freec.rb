class Freec < Formula
  desc "Copy number and genotype annotation in whole genome/exome sequencing data"
  homepage "http://bioinfo.curie.fr/projects/freec/"
  url "https://github.com/BoevaLab/FREEC/archive/v10.4.tar.gz"
  sha256 "d01f44c42318f251c24717b864ef624427e1361069f8fb694f5c52884276fca8"
  head "https://github.com/BoevaLab/FREEC.git"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btr670"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed1d71e9368ef02b10ceebb8309c2d327b5df5da2f141b9f523a9a7e46feccee" => :sierra
    sha256 "2a834bd23c855197b7f827e83c92c9abe84cb014bbb6d616a768ae5b7e4608bf" => :el_capitan
    sha256 "fc4d276ed1ee24dac4a56e412c51fa5ff44923876d0725f9483f1c01b0bf98a8" => :yosemite
    sha256 "c00af7ff6c822332226b9306adb171435465e56d3150119c7c51ae88e4b0e71c" => :x86_64_linux
  end

  def install
    cd "src" do
      system "make"
      bin.install "freec"
    end
    pkgshare.install "scripts", "data"
  end

  test do
    assert_match "FREEC v#{version}", shell_output("#{bin}/freec 2>&1")
  end
end
