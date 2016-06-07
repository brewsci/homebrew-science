class Stringtie < Formula
  homepage "http://ccb.jhu.edu/software/stringtie"
  head "https://github.com/gpertea/stringtie"
  bottle do
    cellar :any
    sha256 "de3a457c45fc023c2b9c4e2d8530ec77ade761269897af535fb82a5a904bb354" => :yosemite
    sha256 "157abc752800f726bce574ac5dc1322e2ed112b953fdd06dcdf819c1d7abf258" => :mavericks
    sha256 "03e7791e8119e5ab2e38eb417bd289f6a266bede9d52bbd98a33e79797c98785" => :mountain_lion
    sha256 "d3274cea211bb0ff362eda641097ca9abbd7ab02fc4cbe37d45579140cbfd495" => :x86_64_linux
  end

  # doi "10.1038/nbt.3122"
  # tag "bioinformatics"

  url "http://ccb.jhu.edu/software/stringtie/dl/stringtie-1.0.4.tar.gz"
  sha256 "635099d543bfaf0ec1c84020eb4aa3375714c12e2d0d435dae44901d49fe3ef2"

  def install
    system "make", "release"
    bin.install "stringtie"
    doc.install "README", "LICENSE"
  end

  test do
    assert_match "transcripts", shell_output("stringtie 2>&1", 1)
  end
end
