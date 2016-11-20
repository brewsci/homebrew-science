class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.27.tar.gz"
  sha256 "cab80b19a15830493a0315f13871f33d384534fec721b89c3d3bc56c9d6f1f3c"

  bottle do
    cellar :any_skip_relocation
    sha256 "a62714cd3079ab7c4a28c43e1c0d76244f8e4fd3266ce3cb4a8282155c90015e" => :sierra
    sha256 "a26637c031ab88ec9a80ce76931ae7780869138629b61f59d073203cfb059236" => :el_capitan
    sha256 "02630b548f002e965a2fd88fbf1fc1fae723685ad8697e9b623364fd301031b2" => :yosemite
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
