class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.36.tar.gz"
  sha256 "302336d88a791812c54c120d14332035fd2ba328932048fab0a13c26ffaf5a24"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a981734cff77c5b5219d1f5d13bf2eeaef0a8135dd6aa7343c238f45720273a" => :sierra
    sha256 "2bd81d306087beda16f45b89cb063f43a0f1ebbbff4312517930b25d29524379" => :el_capitan
    sha256 "e14003d5eb8c1821d5e359a02a6b2fa3b06e8d6cec230089b84fa7a80785708d" => :yosemite
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
