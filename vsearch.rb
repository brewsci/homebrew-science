class Vsearch < Formula
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.3.0.tar.gz"
  sha256 "de255701d791e6a2f2d1a6764b3084ac4a6c4a264d3b583c2283c609f9980ee5"
  head "https://github.com/torognes/vsearch.git"
  # doi "10.5281/zenodo.31443"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3ab9ea62d53de95017d464e1036f57e0b63970494d851fbc692ca813b1206b5" => :sierra
    sha256 "e3ab9ea62d53de95017d464e1036f57e0b63970494d851fbc692ca813b1206b5" => :el_capitan
    sha256 "ef45a18ac0030fa54bb2664030af660cfa31f59eae1e83885de15854582400c4" => :yosemite
    sha256 "32fd3cfcad7dd149086c23a01187a88e95edb3fc2fa32151c2826d1133cd8e17" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "homebrew/dupes/zlib" unless OS.mac?
  depends_on "bzip2" unless OS.mac?

  def install
    system "./autogen.sh"
    system "./configure",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "allpairs_global", shell_output("#{bin}/vsearch --help 2>&1")
  end
end
