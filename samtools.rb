class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "http://www.htslib.org/"
  # doi "10.1093/bioinformatics/btp352"
  # tag "bioinformatics"

  url "https://github.com/samtools/samtools/releases/download/1.4.1/samtools-1.4.1.tar.bz2"
  sha256 "d3d2228c3e3f341f49f33103b11d890cf84b3033d1427334d123a8f5808556fa"

  bottle do
    cellar :any
    sha256 "2527bc30f37e6c98bfdeb11d887608267a081435b0b0a5fd20d5cca7a5834297" => :sierra
    sha256 "9a477c72d577d8b6ccb5f12b5e013acb89b75adde132cb3b5a4c7a1f88fe9467" => :el_capitan
    sha256 "e3e1351c23fd49095ce6cc91e8f3f47731d27d4de827e07ca82ca0f3613e5af1" => :yosemite
    sha256 "43e53ad5cc3c5919c0a5568f9dbf4e728aab91a6713c713495611e32bb52e67a" => :x86_64_linux
  end

  depends_on "htslib"
  unless OS.mac?
    depends_on "ncurses"
    depends_on "zlib"
  end

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
