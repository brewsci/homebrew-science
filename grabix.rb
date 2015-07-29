class Grabix < Formula
  homepage "https://github.com/arq5x/grabix"
  # tag "bioinformatics"
  url "https://github.com/arq5x/grabix/archive/0.1.6.tar.gz"
  sha256 "a1c92311501f583ad1912b6e0394f95d06b8e3aafe1db6a7ba517d5aed161043"
  head "https://github.com/arq5x/grabix.git"

  bottle do
    cellar :any
    sha256 "136a6e742f0b3fbfff7577c90747556cd5848ecbefb2665f883e87be1e757bb6" => :yosemite
    sha256 "fc98a1091a2983421a8dcd76db93197c7f8abeb14c766af0c1a8097537a5ac2f" => :mavericks
    sha256 "3e53adfbd78ca26832fc597f910a1be9590176f6a67228592064495bde14205c" => :mountain_lion
  end

  def install
    system "make"
    bin.install "grabix"
    doc.install "README.md"
    pkgshare.install "simrep.chr1.bed"
  end

  test do
    assert_equal `#{bin}/grabix check #{pkgshare}/simrep.chr1.bed`.chomp, "no"
  end
end
