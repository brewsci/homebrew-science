class Freec < Formula
  desc "Copy number and genotype annotation in whole genome/exome sequencing data"
  homepage "http://bioinfo.curie.fr/projects/freec/"
  url "https://github.com/BoevaLab/FREEC/archive/v10.3.tar.gz"
  sha256 "f15b90dc0fc6629ee32f1a38d1e39f062f20089689b02429f78b585f99504e95"
  head "https://github.com/BoevaLab/FREEC.git"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btr670"

  bottle do
    cellar :any_skip_relocation
    sha256 "176ac03b194be0da3b1403ffa9b1c877344fc7f48586296cb0f4799de2b25bb1" => :sierra
    sha256 "40afc40855875d9f134ba5bff417ea26a245f2c6c9c402dac2909192c6ef7f09" => :el_capitan
    sha256 "76959d16cea8df6eaf0f2c31cb46197e6f168c03a9d09535bceacea23f9b8211" => :yosemite
    sha256 "661683a53de278c90947606c7ebbc4382e3a75a4f19ff4d3cd1fde2a771bfdd1" => :x86_64_linux
  end

  # Patch to fix builds on macOS. Will be present in next release (>10.3)
  patch do
    url "https://github.com/BoevaLab/FREEC/commit/b39300fda339bc4fd9b68727e04f99cdbcbe79b2.diff"
    sha256 "f1ad24896f7d8b60863e7450179334287f12f9fc8ca28e474c01716925f898ca"
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
