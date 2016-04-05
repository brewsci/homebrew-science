class Seqtk < Formula
  desc "Toolkit for processing sequences in FASTA/Q formats"
  homepage "https://github.com/lh3/seqtk"
  # tag "bioinformatics"

  url "https://github.com/lh3/seqtk/archive/v1.1.tar.gz"
  sha256 "f01b9f9af6e443673a0105a7536a01957a4fc371826385a1f3dd1e417aa91d52"

  head "https://github.com/lh3/seqtk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80347faabb214b4a035f9c435be6a4ccbc70142d4a5b593f5c37115f9217ea9b" => :el_capitan
    sha256 "a08757a2d6b5de72f5ab0f08e48457006d621fdcd57b4ce7976e2ed88fc6432e" => :yosemite
    sha256 "6146557f07f725bbe985fb308b7be5b9839bf513db3b4ca63c9a90f37da2e48a" => :mavericks
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
