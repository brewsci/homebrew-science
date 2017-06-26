class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "http://www.htslib.org/"
  # doi "10.1093/bioinformatics/btp352"
  # tag "bioinformatics"

  url "https://github.com/samtools/samtools/releases/download/1.5/samtools-1.5.tar.bz2"
  sha256 "8542da26832ee08c1978713f5f6188ff750635b50d8ab126a0c7bb2ac1ae2df6"

  bottle do
    cellar :any
    sha256 "40fe6e6f0c980d868b2ec75230a1b47deae2d2601b17d5a0d020aac2c0896936" => :sierra
    sha256 "89bf64b374fd0aa557613eba9975d4b613439f781dc2e34823c7d6b0c0963df3" => :el_capitan
    sha256 "5d206a13380f813d6f5a9f6fa01a3904e3d36e9fd5a182e69ea6a69210a2da91" => :yosemite
    sha256 "8df101a333881891edbd8fab8acec2a0fbd089de4c8f3f14bc6b957d9a9fc9e7" => :x86_64_linux
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
