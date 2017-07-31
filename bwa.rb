class Bwa < Formula
  desc "Burrow-Wheeler Aligner for pairwise alignment of DNA"
  homepage "https://github.com/lh3/bwa"
  # doi "10.1093/bioinformatics/btp324"
  # tag "bioinformatics"

  url "https://github.com/lh3/bwa/releases/download/v0.7.16/bwa-0.7.16a.tar.bz2"
  sha256 "8fecdb5f88871351bbe050c18d6078121456c36ad75c5c78f33a926560ffc170"

  head "https://github.com/lh3/bwa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "734b913fe456453ba67bfe02e37b7f717ef9b870c01f03ef2f6ebfb82cfd77e4" => :sierra
    sha256 "f9a0c3548af3a4f9e321255446434e363f8e8c55e783393a6fce4ae19fbed919" => :el_capitan
    sha256 "652bc2644ce315ef6388fd8d21e4fdda945fa0d6cedc74d404ca6eb55281b61d" => :yosemite
  end

  depends_on "zlib" unless OS.mac?

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "bwa"
    doc.install "README.md", "NEWS.md"
    man1.install "bwa.1"
  end

  test do
    (testpath/"test.fasta").write ">0\nAGATGTGCTG\n"
    system "#{bin}/bwa", "index", "test.fasta"
    assert File.exist?("test.fasta.bwt")
    assert_match "AGATGTGCTG", shell_output("#{bin}/bwa mem test.fasta test.fasta")
  end
end
