class Mlst < Formula
  desc "Multi-Locus Sequence Typing of microbial contigs"
  homepage "https://github.com/tseemann/mlst"
  url "https://github.com/tseemann/mlst/archive/1.3.tar.gz"
  sha256 "73f213e95413b3561d2e9cb4f432fd004c31b596a88dd80d2333005deb94b022"
  bottle do
    cellar :any
    sha256 "4beb855b2de3850fc88323e673c4c3edc0479e66368763cf0fdde461dbea2f38" => :yosemite
    sha256 "08de6200b91384a2913834774d49bc927a6f7247eb6ab3ef1671494e0b113d42" => :mavericks
    sha256 "fb7ea7b027fbe6f06254b5b939dda33915ebfbaf86e2b12b561e29f53837bf80" => :mountain_lion
  end

  # tag "bioinformatics"

  depends_on "blat"
  depends_on "File::Temp" => :perl
  depends_on "File::Spec" => :perl
  depends_on "Data::Dumper" => :perl

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "senterica", shell_output("mlst --list 2>&1", 0)
  end
end
