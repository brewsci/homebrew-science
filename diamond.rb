class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.37.tar.gz"
  sha256 "54dcede91053075c7a530de6e4a842a65600b0d5d9eae4b6b4ceab402ac2c7fe"

  bottle do
    cellar :any_skip_relocation
    sha256 "35e82ebd080ed04347f53d626609eca163b4bafb1464eb4cac8d997be69f6795" => :sierra
    sha256 "3e9e70ead7f6e833ef933c2196731429b9f5d860121a2df62a7845d27046a472" => :el_capitan
    sha256 "8141a5cbea84ca82face509356fd9d7e2b0d29fd3138763335785a5aad0a7446" => :yosemite
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
