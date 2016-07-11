class Barrnap < Formula
  desc "BAsic Rapid Ribosomal RNA Predictor"
  homepage "https://github.com/tseemann/barrnap"
  # tag "bioinformatics"

  url "https://github.com/tseemann/barrnap/archive/0.7.tar.gz"
  sha256 "ef2173e250f06cca7569c03404c9d4ab6a908ef7643e28901fbe9a732d20c09b"

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
    assert_match "##gff-version", shell_output("barrnap -q #{prefix}/examples/nohits.fna")
    assert_match "Name=16S_rRNA", shell_output("barrnap -q #{prefix}/examples/small.fna")
    assert_match "Name=16S_rRNA", shell_output("barrnap -q --kingdom mito #{prefix}/examples/mitochondria.fna")
  end
end
