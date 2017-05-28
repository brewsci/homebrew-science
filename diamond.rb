class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.9.2.tar.gz"
  sha256 "f22e68c5672f249ed5632ac0c9689e05db3af9e778b5aabf70e6e5da42a8aa0d"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "a6791c28e06abef69a8d7a9b35c9f13083c11be99d118d571a6ae92ae6c8be53" => :sierra
    sha256 "3cc7f0cb3f00c58e0683e1cb483dae95a2138b22342b6f30a3f1527be2297c66" => :el_capitan
    sha256 "96a0932bb4c9cfa9d05778769a0e608c2b76b68cf1e65f6a2389a203bc6a1576" => :yosemite
    sha256 "713338154343ac18bd86cb39a3559d35632c88c4ace09f51ac2d8a54288c372c" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "zlib" unless OS.mac?

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "gapextend", shell_output("#{bin}/diamond help 2>&1")
  end
end
