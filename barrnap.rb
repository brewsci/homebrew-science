class Barrnap < Formula
  desc "BAsic Rapid Ribosomal RNA Predictor"
  homepage "https://github.com/tseemann/barrnap"
  # tag "bioinformatics"

  url "https://github.com/tseemann/barrnap/archive/0.7.tar.gz"
  sha256 "ef2173e250f06cca7569c03404c9d4ab6a908ef7643e28901fbe9a732d20c09b"

  head "https://github.com/tseemann/barrnap.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "62e01fed459ed2730d05a40ef04f95961f87f7f8" => :yosemite
    sha1 "bb43599e3ba3facc77a888a0403214afed5e0f5e" => :mavericks
    sha1 "81e26c00aeec754174d2825c406207dc14afbc72" => :mountain_lion
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
