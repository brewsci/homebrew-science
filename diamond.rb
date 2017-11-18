class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.9.13.tar.gz"
  sha256 "066d2744ef9e8f3d6f7eba5e6eb226434299b18574c8716bbdd8faca31b325de"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f71474367223dc444c73e5e3ebb36d193496623afbaf4184a2e8dbc5615c4bc" => :high_sierra
    sha256 "165730bec30843096226563be52cd8f06a3e0ab6f66c7d10bc393b49a7ada057" => :sierra
    sha256 "edfa530b27a69a3c286920617bdff2385dcaaf522df0e19138d986c0798cee32" => :el_capitan
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
