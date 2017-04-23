class Freec < Formula
  desc "Copy number and genotype annotation in whole genome/exome sequencing data"
  homepage "http://bioinfo.curie.fr/projects/freec/"
  url "https://github.com/BoevaLab/FREEC/archive/v10.6.tar.gz"
  sha256 "4e82f64bde5ff6ae4f02337c9fe30370282949b205dfc8d4aae5b789d1dd2838"
  head "https://github.com/BoevaLab/FREEC.git"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btr670"

  bottle do
    cellar :any_skip_relocation
    sha256 "080ea2361739550dff5d5edaede5363fd3ae701d2b31a9d54c456e11d06c2f7a" => :sierra
    sha256 "4d3786f520a83fb81834d737cf161b068745eb42bcd44bcb9d64bf08d7188bb7" => :el_capitan
    sha256 "8ed4fedc2039c871deb864349924bc3d2e84cfdba17a1718d18f5f6a8d433476" => :yosemite
    sha256 "74f3469d80fb61023f0826581ebe71c5b4af29a91d4eb47b19fc91d5645e6eee" => :x86_64_linux
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
