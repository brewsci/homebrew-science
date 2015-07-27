class Nonpareil < Formula
  desc "Estimates coverage in metagenomic datasets."
  homepage "http://enve-omics.ce.gatech.edu/nonpareil"
  # doi "10.1093/bioinformatics/btt584"
  # tag "bioinformatics"
  url "https://github.com/lmrodriguezr/nonpareil/archive/v2.4.01.tar.gz"
  sha256 "ca5955e877098ed4a679404ac87635e28a855d15d6970ca51a6be422266c0999"
  head "https://github.com/lmrodriguezr/nonpareil.git"

  bottle do
    cellar :any
    sha1 "9fa1b02ccc8d561c9586b07d854c71227a77739e" => :yosemite
    sha1 "cd8a9999c84c41fc39aaa7f62cc1ab44a3a26300" => :mavericks
    sha1 "11adac7a92b44e5fd171bc1684a8b76fdceb848f" => :mountain_lion
  end
  depends_on "r"
  depends_on :mpi => [:cxx, :optional]

  def install
    system "make", "nonpareil"
    system "make", "mpicpp=#{ENV["MPICXX"]}", "nonpareil-mpi" if build.with? :mpi
    system "make", "prefix=#{prefix}", "mandir=#{man1}", "install"
    libexec.install "test/test.fasta"
  end

  test do
    system "nonpareil", "-s", "#{libexec}/test.fasta", "-b", "#{libexec}/test"
  end
end
