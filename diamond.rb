class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.9.2.tar.gz"
  sha256 "f22e68c5672f249ed5632ac0c9689e05db3af9e778b5aabf70e6e5da42a8aa0d"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ff7d3a501fe63caa7e2d6bcef5e0ab0cf4c5c9c53113f73cc7848d3eb112a55" => :sierra
    sha256 "0d021640de5d2fd3766b0d3802100209391cfa42f7b9e3fc99436b24b431e62c" => :el_capitan
    sha256 "0f6a477bda57e92a5b53174075df616309a573b79a96b96d2ef90bb68b7589e1" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "zlib" unless OS.mac?

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "gapextend", shell_output("#{bin}/diamond help 2>&1")
  end
end
