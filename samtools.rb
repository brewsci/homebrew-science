class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "http://www.htslib.org/"
  # doi "10.1093/bioinformatics/btp352"
  # tag "bioinformatics"

  url "https://github.com/samtools/samtools/releases/download/1.4/samtools-1.4.tar.bz2"
  sha256 "9aae5bf835274981ae22d385a390b875aef34db91e6355337ca8b4dd2960e3f4"

  bottle do
    cellar :any
    sha256 "2527bc30f37e6c98bfdeb11d887608267a081435b0b0a5fd20d5cca7a5834297" => :sierra
    sha256 "9a477c72d577d8b6ccb5f12b5e013acb89b75adde132cb3b5a4c7a1f88fe9467" => :el_capitan
    sha256 "e3e1351c23fd49095ce6cc91e8f3f47731d27d4de827e07ca82ca0f3613e5af1" => :yosemite
  end

  depends_on "htslib"
  depends_on "homebrew/dupes/ncurses" unless OS.mac?

  def install
    system "./configure", "--with-htslib=#{Formula["htslib"].opt_prefix}"
    system "make"

    bin.install Dir["{samtools,misc/*}"].select { |f| File.executable?(f) }
    lib.install "libbam.a"
    (include/"bam").install Dir["*.h"]
    man1.install "samtools.1"
    pkgshare.install "examples"
  end

  test do
    system bin/"samtools", "--help"
  end
end
