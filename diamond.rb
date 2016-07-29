class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.16.tar.gz"
  sha256 "369cbacc8169671a299cb87278a868fea3179da7d4c18eabf04f4c8750a5e482"

  bottle do
    sha256 "e0eb3edc6f875a6b8e37b2d369b27510ec714faf2e94ff414edb94fbd34a1141" => :yosemite
    sha256 "da0750e96465902fbd7827dc2220c2cb298f71ae488d6175885eb2044e2066ad" => :mavericks
    sha256 "459c5a98274de600b7a270e51a589c21bae1add6384fe76d4a4b5c3d988778cb" => :mountain_lion
    sha256 "3a2da6cefa347fd6530eb53ced02e3b10212eb9c560566c7801fde3836fca862" => :x86_64_linux
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
