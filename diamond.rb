class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.20.tar.gz"
  sha256 "6ff2e46400654ad193f9f0c22abf7efea41b18e3598892e07456e08ffbe57099"

  bottle do
    cellar :any_skip_relocation
    sha256 "a17f5d3819c975f28628a09fd56f846c861fee945bb38423bf6d33da2d5d152b" => :el_capitan
    sha256 "ccccae3ce042253abdc68553bbc6d00f005af31268f2933b162eae2b285e41ee" => :yosemite
    sha256 "ea3deff8c6259f9788b1ea907e84dc72dfe640fc9a7500cbdb1f7ece0f536efe" => :mavericks
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
