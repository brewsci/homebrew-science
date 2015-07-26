class Nonpareil < Formula
  homepage 'http://enve-omics.ce.gatech.edu/nonpareil'
  # doi "10.1093/bioinformatics/btt584"
  # tag "bioinformatics"

  url "https://github.com/lmrodriguezr/nonpareil/archive/v2.4.01.tar.gz"
  sha256 "ca5955e877098ed4a679404ac87635e28a855d15d6970ca51a6be422266c0999"

  head "https://github.com/lmrodriguezr/nonpareil.git"

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
