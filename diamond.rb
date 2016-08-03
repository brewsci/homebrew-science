class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.17.tar.gz"
  sha256 "3d5b221f7ec2de0eec5564c9aa45f17cd483c52b6977d22720bb3578c1d7e990"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1a0d3b5f4189b1cfe73b43b20e4a630d235810f81f4e76bb60390645e9c4d08" => :el_capitan
    sha256 "8c9f470bfefc001ca8cf580b15426eb913b716018545f326d2f6a44208398e9f" => :yosemite
    sha256 "e5e6bef6520a2b066cf4f1675445c9aad060d6d2f686923cf4f9ce2779797fc3" => :mavericks
    sha256 "5b211631e200701cfe43ffe82aa7cb778bc0d73b4b73999817c2feabfc3398cf" => :x86_64_linux
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
