class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.19.tar.gz"
  sha256 "332065f4ecbf3bc513611f821fa2e7fad1f6772b09f8045b00cb0f395d255199"

  bottle do
    cellar :any_skip_relocation
    sha256 "869348a486f1ab412dcdd3f9b1093003dd609bacee5fc7cc99482575cb958288" => :el_capitan
    sha256 "31cd4d6eb4d30d1f91650fc428cdbe11556961fb075ddc15938d42acd8c86875" => :yosemite
    sha256 "f1f82fe79a73791318a716be784e11641845786518740801cd7f5f5861fc87d4" => :mavericks
    sha256 "062502789e59edf8d20708a9dcc5d4a57e29ab33e01f41e573ece33ae582a037" => :x86_64_linux
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
