class Freec < Formula
  desc "Copy number and genotype annotation in whole genome/exome sequencing data"
  homepage "http://bioinfo.curie.fr/projects/freec/"
  url "https://github.com/BoevaLab/FREEC/archive/v10.5.tar.gz"
  sha256 "b2841691193a3d03b93318caac7e20f42e820f5033bc13e9bce6307b173cc57c"
  head "https://github.com/BoevaLab/FREEC.git"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btr670"

  bottle do
    cellar :any_skip_relocation
    sha256 "080ea2361739550dff5d5edaede5363fd3ae701d2b31a9d54c456e11d06c2f7a" => :sierra
    sha256 "4d3786f520a83fb81834d737cf161b068745eb42bcd44bcb9d64bf08d7188bb7" => :el_capitan
    sha256 "8ed4fedc2039c871deb864349924bc3d2e84cfdba17a1718d18f5f6a8d433476" => :yosemite
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
