class Bwa < Formula
  desc "Burrow-Wheeler Aligner for pairwise alignment of DNA"
  homepage "https://github.com/lh3/bwa"
  # doi "10.1093/bioinformatics/btp324"
  # tag "bioinformatics"

  url "https://downloads.sf.net/project/bio-bwa/bwa-0.7.12.tar.bz2"
  sha256 "701dcad147ae470d741717a72c369b338df7f80bff4bb8eee8176c66f16d608c"

  head "https://github.com/lh3/bwa.git"

  bottle do
    cellar :any
    revision 1
    sha256 "787af05be50a58ac1e3a39bdde57f939f76628b34651898ba8cbac19005149ca" => :yosemite
    sha256 "af7d34365a5d3a13cedc74f5d26e5640a3638717c8bfc20395bb24de1108aa7f" => :mavericks
    sha256 "4195e81b4ab9758f1e9c4b05c06c504ea8ec240d8ce18436727236f1957a6907" => :mountain_lion
    sha256 "f60955dd3c1980ab4cb3ba65c8db24dba461306389357a5e18c3be74067d0f71" => :x86_64_linux
  end

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
