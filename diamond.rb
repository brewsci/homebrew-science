class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.38.tar.gz"
  sha256 "582a7932f3aa73b0eac2275dd773818665f0b067b32a79ff5a13b0e3ca375f60"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0d07923d11f5ff9884d7fd70ffcf4a47ef7c2f9fe5bd9dd94a0aff2c7ca2373" => :sierra
    sha256 "4af4997f06e1fe67c49429e382f2d4752d029b3718f960325381812e457de19a" => :el_capitan
    sha256 "8a8b51a55e829dce0a27875a80d63ab516a16170056d022c044caad98751d8db" => :yosemite
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
