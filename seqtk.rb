class Seqtk < Formula
  desc "Toolkit for processing sequences in FASTA/Q formats"
  homepage "https://github.com/lh3/seqtk"
  # tag "bioinformatics"

  url "https://github.com/lh3/seqtk/archive/v1.1.tar.gz"
  sha256 "f01b9f9af6e443673a0105a7536a01957a4fc371826385a1f3dd1e417aa91d52"

  head "https://github.com/lh3/seqtk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f9f294d0dc6e875928753bda692c5f0a13290bd2f16f06642921640d9539600" => :el_capitan
    sha256 "3ba2a3a19f2b128a9b41130d023254bb16688cd2c1945b237ca20aba89023968" => :yosemite
    sha256 "5e32f0a3a7dfdf836c1ed54377136459772011bb1829fc7a8695064b8c4badb3" => :mavericks
  end

  def install
    system "make"
    bin.install "seqtk"
    doc.install "README.md"
  end

  test do
    assert_match "seqtk", shell_output("#{bin}/seqtk 2>&1", 1)
  end
end
