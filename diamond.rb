class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.9.10.tar.gz"
  sha256 "0dafd2180466e3617a949cc33bd5ff6ce1673adac3967a11c4ad58521eff188f"

  bottle do
    cellar :any_skip_relocation
    sha256 "92e628c1c577a845cdb850beaa0d80f234752c27ec2cb17515d065a59c6e40c3" => :sierra
    sha256 "b217f41ab04343bbe6e6d41c824a0515c4e174cc5a8520d6cb45868220beb995" => :el_capitan
    sha256 "61c9d2a8400d23cb4bbcd179d81347464e720c4cb5bfb694bacaeef92ca26cbe" => :yosemite
    sha256 "be4ede7b374a913a5a96492fad9129f2686c6a422cb3914463c471612de57e88" => :x86_64_linux
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
