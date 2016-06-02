class Bwa < Formula
  desc "Burrow-Wheeler Aligner for pairwise alignment of DNA"
  homepage "https://github.com/lh3/bwa"
  # doi "10.1093/bioinformatics/btp324"
  # tag "bioinformatics"

  url "https://github.com/lh3/bwa/releases/download/v0.7.13/bwa-0.7.13.tar.bz2"
  sha256 "559b3c63266e5d5351f7665268263dbb9592f3c1c4569e7a4a75a15f17f0aedc"

  head "https://github.com/lh3/bwa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d285efa2136c1345ff08dc8b2dbc83e8703fe8f3ee7b163d2b10744012ab9cf" => :el_capitan
    sha256 "97358a24e7bdc93005ecff8a54145553592ddded04f354ed2451b1d82e59122f" => :yosemite
    sha256 "ce2ae47bdf1d5995bb6365e4caed2a8b98b5ffa816b7aeff232ed58b86a25fc8" => :mavericks
    sha256 "b54a5bbfdb239106ff18b1b0ac73f9f183c0fbc907c5d6134c489628830dc3dd" => :x86_64_linux
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
