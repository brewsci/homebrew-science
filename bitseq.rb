class Bitseq < Formula
  desc "Transcript isoform level expression and differential expression estimation for RNA-seq"
  homepage "https://bitseq.github.io/"
  url "https://github.com/BitSeq/BitSeq/archive/v0.7.5.tar.gz"
  sha256 "017eb516041de923ecdb5f7122bc2f4f1f99bbc08962028891a6bc845319ac2d"

  head "https://github.com/BitSeq/BitSeq.git"

  needs :openmp
  needs :cxx11

  def install
    ENV.cxx11
    system "make", "LDFLAGS=-Wl,-dead_strip"
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
