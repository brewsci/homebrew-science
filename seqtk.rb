require "formula"

class Seqtk < Formula
  homepage "https://github.com/lh3/seqtk"
  url "https://github.com/lh3/seqtk.git", :revision => "73866e7cc"
  version "2014-09-12-r68"
  head "https://github.com/lh3/seqtk.git"

  def install
    system "make"
    bin.install "seqtk"
    doc.install "README.md"
  end

  test do
    system "seqtk 2>&1 |grep -q seqtk"
  end
end
