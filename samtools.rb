class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "http://www.htslib.org/"
  # doi "10.1093/bioinformatics/btp352"
  # tag "bioinformatics"

  url "https://github.com/samtools/samtools/releases/download/1.4.1/samtools-1.4.1.tar.bz2"
  sha256 "d3d2228c3e3f341f49f33103b11d890cf84b3033d1427334d123a8f5808556fa"

  bottle do
    cellar :any
    sha256 "4c39f772e1de3fbfc6696c7a24272c5baf652ca0bddacd1b35cf6e86390207b8" => :sierra
    sha256 "07d9e66e4955764137c84eaaa46c6f86339ab484e1dd0c742f900e0ae52a00b9" => :el_capitan
    sha256 "9937f5e425beb315cf651be0b16e7b1d389e4eefabd6476bf12572c07d3ff800" => :yosemite
    sha256 "e65fe99e7ca7c18c862acf889295ffc9cdedfb55afef2be01d112c5653a6b554" => :x86_64_linux
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
