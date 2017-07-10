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
    sha256 "52ef46289fafd3f961496e8435c253ca8ad9eb2b8c71e347af151a945e0c931d" => :sierra
    sha256 "9b3f754d24a58fa2984ed909146517e69921ec64b9c07155e1137e198d1b7c44" => :el_capitan
    sha256 "9d3e79f2ad412888dc27ec4d1a15f547de6f72d06794c9e61f4b62b83fb73357" => :yosemite
    sha256 "14076bdc6aa35e126c70b451534f429974f2303b1245a0030590550cd94c9b77" => :x86_64_linux
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
