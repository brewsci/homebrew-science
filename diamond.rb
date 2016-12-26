class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.30.tar.gz"
  sha256 "ee138e4241c2712d6ce967785474312c52a45c6b56715b00e2abf759605e1fbb"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef0b3e494a54ebe0babc20306337d243056b92ceef342dfd4c90aaaf874d232d" => :sierra
    sha256 "ec6c1681277de4e1ee422a7a86c44480b3a5d95339f021b017ca73bc27b65518" => :el_capitan
    sha256 "a30619046985c5d61cd2813efec10a881cd29c397d29f161a1cea7b16767be75" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "gapextend", shell_output("#{bin}/diamond help 2>&1")
  end
end
