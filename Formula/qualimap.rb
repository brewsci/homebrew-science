class Qualimap < Formula
  desc "Facilitates the quality control of alignment sequencing data"
  homepage "http://qualimap.bioinfo.cipf.es/"
  url "https://bitbucket.org/kokonech/qualimap/downloads/qualimap-build-28-03-16.tar.gz"
  version "20160328"
  sha256 "12fd342a2ccc76ea09bbd5e9ae38c1ae9ae44aad5e6f0296298e584e55b0d8ae"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any_skip_relocation, el_capitan: "87452d8d5cc0dc5a4a4a52952ac94c2804fa3935c2a66685026a595bc9d39c63"
    sha256 cellar: :any_skip_relocation, yosemite:   "91e74025f9f2a738abecbdb3529f0e70bf427402a5ab06f18f41e793c1a46d6f"
    sha256 cellar: :any_skip_relocation, mavericks:  "5659d4fef01656d4e8e70394e125e579e1f67090c692434fad1f6244a578a234"
  end

  depends_on "r" => :optional

  def install
    inreplace "qualimap", /-classpath [^ ]*/, "-classpath '#{libexec}/*'"
    bin.install "qualimap"
    libexec.install "scripts", "species", "qualimap.jar", *Dir["lib/*.jar"]
    doc.install "QualimapManual.pdf"
  end

  test do
    system "qualimap", "-h"
  end
end
