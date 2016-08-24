class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.19.tar.gz"
  sha256 "332065f4ecbf3bc513611f821fa2e7fad1f6772b09f8045b00cb0f395d255199"

  bottle do
    cellar :any_skip_relocation
    sha256 "36842d879853ba704977dacdbd22339856d006e83d6ee588082c789c4b914cc1" => :el_capitan
    sha256 "ac087e8e12bf3b2d986e7b012b3120186ed3b8aa772233c40fd23450747f739a" => :yosemite
    sha256 "11f825b2e978615e3c406dfb7034b23975f14bda8d196e777adafce3bd80aeea" => :mavericks
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
