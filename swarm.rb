class Swarm < Formula
  desc "Robust and fast clustering method for amplicons"
  homepage "https://github.com/torognes/swarm"
  url "https://github.com/torognes/swarm/archive/v2.2.2.tar.gz"
  sha256 "960f9b7db1142f0b5761e5ba02bedde09f9d9816c0f8275746fd856af3dfac12"
  head "https://github.com/torognes/swarm.git"
  # doi "10.7717/peerj.1420", "10.7717/peerj.593"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "58e38cb1046d4dff96066405ec4e55cbe1154f540dbc245d892630bb5275d141" => :high_sierra
    sha256 "43ad4be032757551445c54ff9eecba84ef479c56d3de98cce0f669e6b56b2841" => :sierra
    sha256 "22d69a53950a4e092c8994b6fd7ab8bfa2af1c45815d4c7fe5e2b8cc5356191e" => :el_capitan
    sha256 "64db41e64fdbbfcd03caea1122ffef9c6786b2801bfdebea1c7598cb0babc0af" => :x86_64_linux
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
