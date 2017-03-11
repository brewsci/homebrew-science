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
    sha256 "28d50ca0f25ad09c9c53f819ac6925e632b269c3d91035d20ead24297b38ca01" => :sierra
    sha256 "28d50ca0f25ad09c9c53f819ac6925e632b269c3d91035d20ead24297b38ca01" => :el_capitan
    sha256 "d50d062d486534d986bb3fab4fe86467cbbedbbd56812c68df7e282415b66a03" => :yosemite
    sha256 "50c354522e0f92203e1b3d394f53c9d709ce1377f292e426603e28d3d6625062" => :x86_64_linux
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
