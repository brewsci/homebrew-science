require "formula"

class Seqtk < Formula
  homepage "https://github.com/lh3/seqtk"
  #tag "bioinformatics"
  url "https://github.com/lh3/seqtk/archive/73866e7.tar.gz"
  sha1 "fca37571bb4d49ab8cbbddc284072c8fb4a411f2"
  version "1.0-r68"

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
