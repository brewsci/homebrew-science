class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.29.tar.gz"
  sha256 "7f50453153cee83bc38dc1a8983d8e4d6bc455515542161d5c62de11fc91d0d6"

  bottle do
    cellar :any_skip_relocation
    sha256 "f30dee7a6d6418d5f0041ef94d3fbfdf3d27f883a6732c8cdd827bfe52438156" => :sierra
    sha256 "978a6e75f38066f2a1d0aa873aedfb5f4f0dd8e06f57c31121b1472bd1bb3830" => :el_capitan
    sha256 "632c72577efc7dd89261af23ffc9b4559b6aad69fb9b318ebb13c9758679cb2b" => :yosemite
    sha256 "a14c940f6b8d641954c9bd066231b249d96943642f8608919f6aa8dd17236288" => :x86_64_linux
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
