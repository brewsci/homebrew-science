class SnapAligner < Formula
  homepage "http://snap.cs.berkeley.edu"
  #doi "arXiv:1111.5572v1"
  #tag "bioinformatics"

  url "https://github.com/amplab/snap/archive/v0.15.tar.gz"
  sha1 "f104f35f4209554a43ccfc8c353bd71213791a64"
  head "https://github.com/amplab/snap.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "1156de4f5ae32546089cf7d7959ced5dd84d766f" => :yosemite
    sha1 "1222129ca847bce9e868afc049a6133d099233ab" => :mavericks
    sha1 "50834c97faf37fd27d1f3361567b86c215f0388a" => :mountain_lion
  end

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
