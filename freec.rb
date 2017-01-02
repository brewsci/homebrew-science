class Freec < Formula
  desc "Copy number and genotype annotation in whole genome/exome sequencing data"
  homepage "http://bioinfo.curie.fr/projects/freec/"
  url "https://github.com/BoevaLab/FREEC/archive/v10.3.tar.gz"
  sha256 "f15b90dc0fc6629ee32f1a38d1e39f062f20089689b02429f78b585f99504e95"
  head "https://github.com/BoevaLab/FREEC.git"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btr670"

  bottle do
    cellar :any
    sha256 "af7558fda0442a9c242abeb6a9492d82926197f14b31b3e0059a067189e1ae93" => :yosemite
    sha256 "f02914ae0075e54a4378d771f9dd5a98aa67da035606040b707758f9ead7163d" => :mavericks
    sha256 "d7571b435829f2f7356cefdf542cd4563f5e0df038673ce201ab7237bc3ff73b" => :mountain_lion
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
