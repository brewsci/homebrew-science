class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.34.tar.gz"
  sha256 "695c33c43beab64de75f14cccec84d75477a37d02bad1ffef9eb19321e19794b"

  bottle do
    cellar :any_skip_relocation
    sha256 "f630dbfd95b7fc24a3bd167661ae7ece5d1c4df3f82218f6cd2669b0a0d50e09" => :sierra
    sha256 "e3a3d5cb749a45fc58cbdf736e04b1c62087be3dc79b8631b34e5618204bb805" => :el_capitan
    sha256 "708ac4ed466bc58f10fdbced5e3928354fb502f15ca329445e09a0934f435f0a" => :yosemite
    sha256 "3e3ecb42e06bbcd058fbd33f50fe3fff9630399836c5aafd7f20de938c085bea" => :x86_64_linux
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
