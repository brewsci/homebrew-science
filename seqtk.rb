class Seqtk < Formula
  desc "Toolkit for processing sequences in FASTA/Q formats"
  homepage "https://github.com/lh3/seqtk"
  # tag "bioinformatics"

  url "https://github.com/lh3/seqtk/archive/v1.2.tar.gz"
  sha256 "bd53316645ab10f0aaba59e1e72c28442ee4c9c37fddaacce5e24757eff78d7b"

  head "https://github.com/lh3/seqtk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f9f294d0dc6e875928753bda692c5f0a13290bd2f16f06642921640d9539600" => :el_capitan
    sha256 "3ba2a3a19f2b128a9b41130d023254bb16688cd2c1945b237ca20aba89023968" => :yosemite
    sha256 "5e32f0a3a7dfdf836c1ed54377136459772011bb1829fc7a8695064b8c4badb3" => :mavericks
    sha256 "e4c54fa49b50a2e9a69bd60aa31b707cb053e728f7f285f224e1f20ad40dc398" => :x86_64_linux
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
