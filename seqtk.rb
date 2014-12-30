class Seqtk < Formula
  homepage "https://github.com/lh3/seqtk"
  #tag "bioinformatics"

  url "https://github.com/lh3/seqtk/archive/08b3625c2a7aae3eca9ab056e1adea52ec22cbef.tar.gz"
  sha1 "7274ebab93caa66d3a75aada784ee5679834d504"
  version "75"

  head "https://github.com/lh3/seqtk.git"

  def install
    system "make"
    bin.install "seqtk"
    doc.install "README.md"
  end

  test do
    system "#{bin}/seqtk 2>&1 |grep -q seqtk"
  end
end
