class SnapAligner < Formula
  homepage "http://snap.cs.berkeley.edu"
  #doi "arXiv:1111.5572v1"
  #tag "bioinformatics"

  url "https://github.com/amplab/snap/archive/v0.15.tar.gz"
  sha1 "f104f35f4209554a43ccfc8c353bd71213791a64"
  head "https://github.com/amplab/snap.git"

  conflicts_with "snap", :because => "both install bin/snap"

  def install
    system "make"
    bin.install "snap"
    doc.install "LICENSE", "README.md"
  end

  test do
    system "#{bin}/snap |grep SNAP"
  end
end
