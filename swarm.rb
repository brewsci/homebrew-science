class Swarm < Formula
  desc "Robust and fast clustering method for amplicons"
  homepage "https://github.com/torognes/swarm"
  # doi "10.7717/peerj.1420", "10.7717/peerj.593"
  # tag "bioinformatics"

  url "https://github.com/torognes/swarm/archive/v2.1.9.tar.gz"
  sha256 "cf9b580ebd57bbc6d074fbfef42b3ec0f9d24a50436822deb34ee1a9a94044cb"
  head "https://github.com/torognes/swarm.git"

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
