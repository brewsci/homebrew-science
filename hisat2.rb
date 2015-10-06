class Hisat2 < Formula
  desc "graph-based alignment to a population of genomes"
  homepage "http://ccb.jhu.edu/software/hisat2/"
  # tag "bioinformatics"
  url "https://ccb.jhu.edu/software/hisat2/downloads/hisat2-2.0.0-beta-source.zip"
  sha256 "12ce17a34d3c3e5f546e6204a49aeb65c860c42fce7ac2a77c6c0b690d934fbf"

  def install
    system "make"
    bin.install "hisat2", Dir["hisat2-*"]
    doc.install Dir["doc/*"]
  end

  test do
    assert_match "HISAT2", shell_output("hisat2 2>&1", 1)
  end
end
