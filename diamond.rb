class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.23.tar.gz"
  sha256 "229e6a55bf00e88d7c9f16bd3510dd926654685e65fa7757178591b9dcc0ec76"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0722fc7a5a41777fad177072a3b2cf5f29dd6bc4d41e90e1d5443c8cac56d4e" => :sierra
    sha256 "882bbc210ecd382ab4d95880e8ad8956497026b3705f597ef53888e208c09c1c" => :el_capitan
    sha256 "4f68633817fa0aafcccd6507f17b80fd2d72ec569afe7f981e9f54241d97019c" => :yosemite
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
