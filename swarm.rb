class Swarm < Formula
  desc "Robust and fast clustering method for amplicons"
  homepage "https://github.com/torognes/swarm"
  url "https://github.com/torognes/swarm/archive/v2.1.13.tar.gz"
  sha256 "ec4b22cc1874ec6d2c89fe98e23a2fb713aec500bc4a784f0556389d22c02650"
  head "https://github.com/torognes/swarm.git"
  # doi "10.7717/peerj.1420", "10.7717/peerj.593"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "010055733aceedc5180a5c9b8f32c0060a6292bcd109ab861d72807033f8e603" => :sierra
    sha256 "161cb94c5a8837b505c539b6f7448ae24ec4c23c460f73db8d6d7e78740cee75" => :el_capitan
    sha256 "0788d7520dfac293d8ea8967b3856f229ea403b886a9fcdd82c520154b173c61" => :yosemite
    sha256 "3203b8beaec1f2d3ab0c9ee4d427a322cb3156484c21393802fa614782f6f27d" => :x86_64_linux
  end

  def install
    system "make", "-C", "src"
    bin.install "bin/swarm"
    man1.install "man/swarm.1"
    doc.install "man/swarm_manual.pdf", "CITATION", "LICENSE", "README.md"
  end

  test do
    assert_match "Quince", shell_output("#{bin}/swarm --version 2>&1", 0)
  end
end
