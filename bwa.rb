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
    sha256 "e0e7e4026b7866edd1bdeda620411742b95ceda0fc55ceaa477bfd78aa1628a5" => :high_sierra
    sha256 "beadf03b7a3d202e6931755e0e40fdcf218c3a57b26e701772e6e31b117575bc" => :sierra
    sha256 "4fdd0af4751761bc123211a5f67e25b82827eec68713328107ab24cb11cfa763" => :el_capitan
    sha256 "5b82162cc3e2f2c3c2da9fc3e47e0118e1bf92e7b5397c1373825f50cf4f31ac" => :x86_64_linux
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
