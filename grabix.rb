class Grabix < Formula
  homepage "https://github.com/arq5x/grabix"
  # tag "bioinformatics"
  url "https://github.com/arq5x/grabix/archive/0.1.5.tar.gz"
  sha256 "b3eee3f95f2a3c90f5b652c0f1259e9c9a44a541788d3116444760c6a9c26165"
  head "https://github.com/arq5x/grabix.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "47903048212bd2cbe4ef80745860bee4aa719d249626251e5f41ab943c5ff6d0" => :yosemite
    sha256 "298640d3efa6b8cc3f24f9bdd1025330b4f397d48d6694b37829acef381f841b" => :mavericks
    sha256 "b5f9657e9017f8bb29988184da0fbdd0bdb8a7a9462722ff12e2b80ca9ae936c" => :mountain_lion
  end

  def install
    system "make"
    bin.install "grabix"
    doc.install "README.md"
    share.install "simrep.chr1.bed"
  end

  test do
    assert_equal `#{bin}/grabix check #{share}/simrep.chr1.bed`.chomp, "no"
  end
end
