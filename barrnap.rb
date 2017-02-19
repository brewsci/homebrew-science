class Barrnap < Formula
  desc "BAsic Rapid Ribosomal RNA Predictor"
  homepage "https://github.com/tseemann/barrnap"
  # tag "bioinformatics"

  url "https://github.com/tseemann/barrnap/archive/0.8.tar.gz"
  sha256 "82004930767e92b61539c0de27ff837b8b7af01236e565f1473c63668cf0370f"

  head "https://github.com/tseemann/barrnap.git"

  bottle do
    cellar :any
    sha256 "fec76972178844abb223274fc4a3c45b987168d2163c4074998100d688a97e6a" => :yosemite
    sha256 "3d84c1dfdac365506270abd6df0e0c451ef43df9039829d52eefe7b59ada2b14" => :mavericks
    sha256 "362da60326bfc61270f00879a30ecfb97e423893c210612c292f6c0e51ec4d81" => :mountain_lion
    sha256 "a26f2a63f43fecac5a5bdead99174288a207075c60f278b7bcea7cbb3c708dad" => :x86_64_linux
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
