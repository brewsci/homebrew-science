class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "http://www.htslib.org/"
  # doi "10.1093/bioinformatics/btp352"
  # tag "bioinformatics"

  url "https://github.com/samtools/samtools/releases/download/1.6/samtools-1.6.tar.bz2"
  sha256 "ee5cd2c8d158a5969a6db59195ff90923c662000816cc0c41a190b2964dbe49e"

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
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    assert_equal "", shell_output("#{bin}/samtools faidx test.fasta")
    assert_equal "U00096.2:1-70\t70\t15\t70\t71\n", (testpath/"test.fasta.fai").read
  end
end
