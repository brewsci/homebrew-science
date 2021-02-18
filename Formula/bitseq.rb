class Bitseq < Formula
  desc "RNA-seq analysis library"
  homepage "https://bitseq.github.io/"
  url "https://github.com/BitSeq/BitSeq/archive/v0.7.5.tar.gz"
  sha256 "017eb516041de923ecdb5f7122bc2f4f1f99bbc08962028891a6bc845319ac2d"

  head "https://github.com/BitSeq/BitSeq.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-science"
    sha256 cellar: :any, el_capitan: "53a4eb9db5d4368738234abe42096d0658fd932b87d0b48841b638a4f8446654"
    sha256 cellar: :any, yosemite:   "17c3a8bc0ab1552eb0a00e9f51739dadbcfc0d647413dd542d498608a7a6b13b"
    sha256 cellar: :any, mavericks:  "c779feb24ca6061132f4d68af03b5301daa5a2c9eb1c85ffe21a0eda838d4fef"
  end

  needs :openmp

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
