class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "http://www.htslib.org/"
  # doi "10.1093/bioinformatics/btp352"
  # tag "bioinformatics"

  url "https://github.com/samtools/samtools/releases/download/1.6/samtools-1.6.tar.bz2"
  sha256 "ee5cd2c8d158a5969a6db59195ff90923c662000816cc0c41a190b2964dbe49e"

  bottle do
    cellar :any
    sha256 "76ca9e2ceb35329c7c265da03f6aa818b04974e6be46cdf6c4fef308bd5efebd" => :high_sierra
    sha256 "51fdc69eedc8a989999b8e282c5cf1f32230d156018197fbb25c4bb5c5a6f3af" => :sierra
    sha256 "be3e92f9ed5d5c6fb2c8b369d09b1bff6f6b4b605f23bb6fd032e3f53a69ceb6" => :el_capitan
    sha256 "52c8153f45e3d5003c35a941ba4273f69a33cafb652f67ebb4b0c467c1b158ff" => :x86_64_linux
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
