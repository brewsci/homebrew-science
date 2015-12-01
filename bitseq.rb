class Bitseq < Formula
  homepage "https://code.google.com/p/bitseq/"
  url "https://bitseq.googlecode.com/files/BitSeq-0.4.3.tar.gz"
  sha256 "72ebc757ea42060c3ad7fb49f76e3af3934da6058909a193c167f97223c9a8cc"

  needs :openmp

  def install
    system "make"
    bin.install "convertSamples",
                "estimateDE",
                "estimateExpression",
                "estimateHyperPar",
                "extractSamples",
                "getFoldChange",
                "getGeneExpression",
                "getPPLR",
                "getVariance",
                "getWithinGeneExpression",
                "parseAlignment",
                "transposeLargeFile"
  end

  test do
    system "#{bin}/parseAlignment", "--help"
  end
end
