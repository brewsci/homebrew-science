class Hisat < Formula
  homepage "http://ccb.jhu.edu/software/hisat/"
  # tag "bioinformatics"
  # doi "10.1038/nmeth.3317"
  url "http://ccb.jhu.edu/software/hisat/downloads/hisat-0.1.5-beta-source.zip"
  sha256 "0a58d820297fae2f90a783bdb714621a6051fe2bde0a60d518cb3672eeda2210"
  version "0.1.5b"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "d9540bb34062a9037d402352f99a61f6cda54732460d3eab39f439a4ea449fdf" => :yosemite
    sha256 "30639176fdd893df3b6d64761a09de3a44ada9cb038771296651e2277dabf6f8" => :mavericks
    sha256 "12d5c4dc85b63920c6e0e6b7808336fd7818111e88e940552ec663557e0d4b60" => :mountain_lion
  end

  def install
    system "make"
    bin.install "hisat", Dir["hisat-*"]
    doc.install Dir["doc/*"]
  end

  test do
    assert_match "HISAT", shell_output("hisat 2>&1", 1)
  end
end
