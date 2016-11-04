class Centrifuge < Formula
  desc "Rapid sensitive classification of metagenomic sequences"
  homepage "http://www.ccb.jhu.edu/software/centrifuge"
  url "https://github.com/infphilo/centrifuge/archive/f39767eb57d8e175029c.tar.gz"
  version "1.0.3-beta"
  sha256 "9561f0b106f66e966b10e5add1ffe4507eb02a65a69741e07b0f6f24a240ccea"
  head "https://github.com/infphilo/centrifuge"
  # doi "10.1101/054965"
  # tag "bioinformatics"

  needs :openmp

  def install
    system "make"
    bin.install "centrifuge", Dir["centrifuge-*"]
    pkgshare.install "example", "indices", "evaluation"
    doc.install "doc", "MANUAL", "TUTORIAL"
  end

  def caveats
    <<-EOS.undent
      The Makefile for building indices was installed to:
        #{pkgshare}/indices
    EOS
  end

  test do
    assert_match "deterministic", shell_output("#{bin}/centrifuge --help 2>&1")
  end
end
