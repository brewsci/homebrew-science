class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.26.tar.gz"
  sha256 "00d2be32dad76511a767ab8e917962c0ecc572bc808080be60dec028df45439f"

  bottle do
    cellar :any_skip_relocation
    sha256 "db899e29c438f1002dafdb3b22811683f486b878db6cfdc0a848948ebd36cfb2" => :sierra
    sha256 "5155f5e55a77b6fa626112d3739bd56bb227ad6327cb18b84c61fc241142bee5" => :el_capitan
    sha256 "b5eca8d028b24712750fa3cd42a817bd5efa5ff64670d77e4bc07600532514bd" => :yosemite
    sha256 "cac7e089e8cd168c4347533b6a846a23e0084207f7d8c7b04e920b4edcc720f6" => :x86_64_linux
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
