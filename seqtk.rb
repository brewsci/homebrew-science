class Seqtk < Formula
  desc "Toolkit for processing sequences in FASTA/Q formats"
  homepage "https://github.com/lh3/seqtk"
  # tag "bioinformatics"

  url "https://github.com/lh3/seqtk/archive/v1.2.tar.gz"
  sha256 "bd53316645ab10f0aaba59e1e72c28442ee4c9c37fddaacce5e24757eff78d7b"

  head "https://github.com/lh3/seqtk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d26cf785f5c4d4eceb170198423b1d77be751aba18e4c72ef2f21bf946817ae" => :el_capitan
    sha256 "e4b6134eb4970b82fba4a291aef6f702c93a449033026f0f6c96dd71001e855b" => :yosemite
    sha256 "e0bb91282b4ed3c52a61f63f5bd6dcfab3131a567a744df9dd8778e8f4b7ff75" => :mavericks
    sha256 "e92f2efea04c95b48b337c6b5de2e46f31c2c45e7543e1a621a6c9a1a8efcf4e" => :x86_64_linux
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
