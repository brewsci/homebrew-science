class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.22.tar.gz"
  sha256 "a1cdd0c7838839fa92cf8d06990c9e210cc2702681e5b61bc917fdc20e507851"

  bottle do
    cellar :any_skip_relocation
    sha256 "191b41a1ded8853bf5eca50ab7bc0d25d425d07c1d6e76b275e4606f9a831df6" => :el_capitan
    sha256 "5d4510c1d158b3cec4a1a971d78df5bd1eef54bed2611d511325d921b4dfb092" => :yosemite
    sha256 "740c0187351f10105039b409405c11a990ad7ec7f9a4711882a21e463bb37739" => :mavericks
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
