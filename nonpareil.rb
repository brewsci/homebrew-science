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
    sha256 "654afb8d18101c7a82c96b5c3254e6fec0d6816df24cdc90d4b92af7fc06a419" => :yosemite
    sha256 "a130e6c42e95307364af276989286ffbdef539281f46e5246426ed6864adcd40" => :mavericks
    sha256 "85fecd99f93abe1e30fdc17ca997bb94bcccb97a0d84e8e5fc1d23bff98e38cf" => :mountain_lion
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
