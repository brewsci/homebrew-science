class Freec < Formula
  desc "Copy number and genotype annotation in whole genome/exome sequencing data"
  homepage "http://bioinfo.curie.fr/projects/freec/"
  url "https://github.com/BoevaLab/FREEC/archive/v11.0.tar.gz"
  sha256 "5f3b2609dac5e90e968ec20225a0ec110882c1966781896ad11e8433c13adc88"
  head "https://github.com/BoevaLab/FREEC.git"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btr670"

  bottle do
    cellar :any_skip_relocation
    sha256 "a76515502af6f05a2fd2c63c6cb16095a7ba6e698b8318ea6d8e1356393899f3" => :sierra
    sha256 "de28e3953dc88d9145ae6e1a7ee006e2c68bce1e2c1fc853a32b69d852f55c9a" => :el_capitan
    sha256 "750b641caa46d2e3316eaddd8d41c04bebff4782522226c0c31229b2e29eb945" => :yosemite
    sha256 "2828a21e47e1a6eb201d15b7bb48c78d74473c354fe1639207cde85cdc632b1c" => :x86_64_linux
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
