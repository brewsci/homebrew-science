class Hisat < Formula
  homepage "http://ccb.jhu.edu/software/hisat/"
  # tag "bioinformatics"
  # doi "10.1038/nmeth.3317"
  url "http://ccb.jhu.edu/software/hisat/downloads/hisat-0.1.5-beta-source.zip"
  sha256 "0a58d820297fae2f90a783bdb714621a6051fe2bde0a60d518cb3672eeda2210"
  version "0.1.5b"

  def install
    system "make"
    bin.install "hisat", Dir["hisat-*"]
    doc.install Dir["doc/*"]
  end

  test do
    assert_match "HISAT", shell_output("hisat 2>&1", 1)
  end
end
