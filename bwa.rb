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
    sha256 "d8341ec482130b67c1a43394b56fcf0eb39da2ed9e37a1c27dbf7d8201901347" => :el_capitan
    sha256 "2906054058cbdad87364cb58c6bbc25d1dc900709e9a2ba0629899d1d7a05bdb" => :yosemite
    sha256 "a75a5025de6c1f1df0e53d005fb752843562271389dbde5fcbc865ca3aed9e7e" => :mavericks
    sha256 "2539f7596fab900908bb4d72ecca16bf505436b2fbc3785b409abd0cdb375011" => :x86_64_linux
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
