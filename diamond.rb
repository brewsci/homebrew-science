class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.33.tar.gz"
  sha256 "5d7dbbbecefb2ecdb53b37ed34843ddae54d18ad91556d68da927fc5696bf81a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f630dbfd95b7fc24a3bd167661ae7ece5d1c4df3f82218f6cd2669b0a0d50e09" => :sierra
    sha256 "e3a3d5cb749a45fc58cbdf736e04b1c62087be3dc79b8631b34e5618204bb805" => :el_capitan
    sha256 "708ac4ed466bc58f10fdbced5e3928354fb502f15ca329445e09a0934f435f0a" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost"

  patch do
    url "https://github.com/bbuchfink/diamond/commit/2913aa4.patch"
    sha256 "203bb13d8bdffcb5ea58062848ea7c23a9f8c8e3c608427769b1681a9d1027d1"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "gapextend", shell_output("#{bin}/diamond help 2>&1")
  end
end
