class Stringtie < Formula
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "http://ccb.jhu.edu/software/stringtie"
  url "http://ccb.jhu.edu/software/stringtie/dl/stringtie-1.2.4.tar.gz"
  sha256 "7fcd64c3ad73816cdb446c5d703a1c46cf828db88871221267532355168b0dc9"
  head "https://github.com/gpertea/stringtie.git"

  # doi "10.1038/nbt.3122"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "de3a457c45fc023c2b9c4e2d8530ec77ade761269897af535fb82a5a904bb354" => :yosemite
    sha256 "157abc752800f726bce574ac5dc1322e2ed112b953fdd06dcdf819c1d7abf258" => :mavericks
    sha256 "03e7791e8119e5ab2e38eb417bd289f6a266bede9d52bbd98a33e79797c98785" => :mountain_lion
    sha256 "d3274cea211bb0ff362eda641097ca9abbd7ab02fc4cbe37d45579140cbfd495" => :x86_64_linux
  end

  def install
    system "make", "release"
    bin.install "stringtie"
    doc.install "README", "LICENSE"
  end

  test do
    assert_match "transcripts", shell_output("stringtie 2>&1", 1)
  end
end
