class Qualimap < Formula
  desc "Facilitates the quality control of alignment sequencing data"
  homepage "http://qualimap.bioinfo.cipf.es/"
  url "https://bitbucket.org/kokonech/qualimap/downloads/qualimap-build-28-03-16.tar.gz"
  version "20160328"
  sha256 "12fd342a2ccc76ea09bbd5e9ae38c1ae9ae44aad5e6f0296298e584e55b0d8ae"
  bottle do
    cellar :any
    sha256 "312dbd9f9a0537ef4ab379d5d65d905455e7f01af827de75643d89beb0e305b0" => :yosemite
    sha256 "8ff12829b1a9ce2cf92a123dfe3e1eaa18b0c7f3929261ae93f6740878e75842" => :mavericks
    sha256 "52cffc28c7504e6c6cb3757533b2f06ea9af32f965818273f93be9a2a5f5f957" => :mountain_lion
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
