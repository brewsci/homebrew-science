class Vsearch < Formula
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.4.2.tar.gz"
  sha256 "dcd871435cc03e1b4b00bb0f75e6085710f58a4612e6dda96c6fbddd5313fe97"
  head "https://github.com/torognes/vsearch.git"
  # doi "10.5281/zenodo.31443"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "2856141db50a4387ae66736dcee614f11efda0722b2cbe96c04e115c49c82cd2" => :sierra
    sha256 "2856141db50a4387ae66736dcee614f11efda0722b2cbe96c04e115c49c82cd2" => :el_capitan
    sha256 "9aaef8ed547a49e1eaaa1129bc9b503fc2f5be6da067cc73712f4697a410d40f" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  unless OS.mac?
    depends_on "bzip2"
    depends_on "zlib"
  end

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
