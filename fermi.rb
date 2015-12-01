class Fermi < Formula
  homepage "https://github.com/lh3/fermi"
  # doi "10.1093/bioinformatics/bts280"
  # tag "bioinformatics"

  url "https://github.com/lh3/fermi/archive/1.1.tar.gz"
  sha256 "0597d82376ddcc76ad6e3a2552300bdc5315a172e8b22d3ada9e68e8bfeb1bc8"
  head "https://github.com/lh3/fermi.git"

  bottle do
    cellar :any
    sha256 "4ad67cf62a8e1a20ab3fe935ed5646d233c0e23e88d590d6f95232784709e5c5" => :yosemite
    sha256 "a2240c62dc918a11afd442021f88486f0c95a54767474e791a7cbde6485cf827" => :mavericks
  end

  def install
    system "make"
    prefix.install "README.md"
    bin.install "fermi", "run-fermi.pl"
  end

  test do
    system "#{bin}/fermi 2>&1 |grep -q fermi"
  end
end
