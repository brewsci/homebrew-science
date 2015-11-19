class Mlst < Formula
  desc "Multi-Locus Sequence Typing of microbial contigs"
  homepage "https://github.com/tseemann/mlst"
  # tag "bioinformatics"

  url "https://github.com/tseemann/mlst/archive/2.0.tar.gz"
  sha256 "21030c8ee57eeab63d06f643b3074e18f81008c05da237250035eb3c779a8448"

  bottle do
    cellar :any
    sha256 "4beb855b2de3850fc88323e673c4c3edc0479e66368763cf0fdde461dbea2f38" => :yosemite
    sha256 "08de6200b91384a2913834774d49bc927a6f7247eb6ab3ef1671494e0b113d42" => :mavericks
    sha256 "fb7ea7b027fbe6f06254b5b939dda33915ebfbaf86e2b12b561e29f53837bf80" => :mountain_lion
  end

  depends_on "blast"
  depends_on "File::Temp" => :perl
  depends_on "File::Spec" => :perl
  depends_on "Data::Dumper" => :perl
  depends_on "List::MoreUtils" => :perl
  depends_on "Moo" => :perl

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "senterica", shell_output("mlst --list 2>&1", 0)
  end
end
