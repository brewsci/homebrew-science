class Bwa < Formula
  desc "Burrow-Wheeler Aligner for pairwise alignment of DNA"
  homepage "https://github.com/lh3/bwa"
  url "https://github.com/lh3/bwa/releases/download/v0.7.17/bwa-0.7.17.tar.bz2"
  sha256 "de1b4d4e745c0b7fc3e107b5155a51ac063011d33a5d82696331ecf4bed8d0fd"
  head "https://github.com/lh3/bwa.git"
  # doi "10.1093/bioinformatics/btp324"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "734b913fe456453ba67bfe02e37b7f717ef9b870c01f03ef2f6ebfb82cfd77e4" => :sierra
    sha256 "f9a0c3548af3a4f9e321255446434e363f8e8c55e783393a6fce4ae19fbed919" => :el_capitan
    sha256 "652bc2644ce315ef6388fd8d21e4fdda945fa0d6cedc74d404ca6eb55281b61d" => :yosemite
    sha256 "6ce60493d6ed784d38b165a55edc3905fef073a6ae10f27a7c7242db6b78fc6d" => :x86_64_linux
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
    assert_predicate testpath/"test.fasta.bwt", :exist?
    assert_match "AGATGTGCTG", shell_output("#{bin}/bwa mem test.fasta test.fasta")
  end
end
