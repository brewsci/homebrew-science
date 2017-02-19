class Barrnap < Formula
  desc "BAsic Rapid Ribosomal RNA Predictor"
  homepage "https://github.com/tseemann/barrnap"
  # tag "bioinformatics"

  url "https://github.com/tseemann/barrnap/archive/0.8.tar.gz"
  sha256 "82004930767e92b61539c0de27ff837b8b7af01236e565f1473c63668cf0370f"

  head "https://github.com/tseemann/barrnap.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a247a3d654a6a7a707150c40d25979bd27bec2dbd8359e73a3d83382d3230c06" => :sierra
    sha256 "a247a3d654a6a7a707150c40d25979bd27bec2dbd8359e73a3d83382d3230c06" => :el_capitan
    sha256 "a247a3d654a6a7a707150c40d25979bd27bec2dbd8359e73a3d83382d3230c06" => :yosemite
    sha256 "daa585fcad3dbc827970f30ff093d51842a20b231358aad77b4b2a0aa472f045" => :x86_64_linux
  end

  depends_on "hmmer"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "##gff-version", shell_output("#{bin}/barrnap -q #{prefix}/examples/nohits.fna")
    assert_match "Name=16S_rRNA", shell_output("#{bin}/barrnap -q #{prefix}/examples/small.fna")
    assert_match "Name=16S_rRNA", shell_output("#{bin}/barrnap -q --kingdom mito #{prefix}/examples/mitochondria.fna")
  end
end
