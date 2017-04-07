class Vsearch < Formula
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.4.3.tar.gz"
  sha256 "f7ffc2aec5d76bdaf1ffe7fb733102138214cec3e3846eb225455dcc3c088141"
  head "https://github.com/torognes/vsearch.git"
  # doi "10.5281/zenodo.31443"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "2856141db50a4387ae66736dcee614f11efda0722b2cbe96c04e115c49c82cd2" => :sierra
    sha256 "2856141db50a4387ae66736dcee614f11efda0722b2cbe96c04e115c49c82cd2" => :el_capitan
    sha256 "9aaef8ed547a49e1eaaa1129bc9b503fc2f5be6da067cc73712f4697a410d40f" => :yosemite
    sha256 "c9e91586915213ff0498f0f1f429b9de08fdce3e6f34d7c1cd7eb68f5bb3fb88" => :x86_64_linux
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
