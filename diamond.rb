class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.31.tar.gz"
  sha256 "b89fec7665346d80dd3e8e0c7fb599117cd0f6c9831cf568dd08bf9b894b075a"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef0b3e494a54ebe0babc20306337d243056b92ceef342dfd4c90aaaf874d232d" => :sierra
    sha256 "ec6c1681277de4e1ee422a7a86c44480b3a5d95339f021b017ca73bc27b65518" => :el_capitan
    sha256 "a30619046985c5d61cd2813efec10a881cd29c397d29f161a1cea7b16767be75" => :yosemite
    sha256 "f80e50147ace5332853d92e340eb03ad8dd023f5a77a5f2c3190a6339f41a2e0" => :x86_64_linux
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
