require 'formula'

class Nonpareil < Formula
  homepage 'http://enve-omics.ce.gatech.edu/nonpareil'
  url 'https://github.com/lmrodriguezr/nonpareil/archive/v2.4.tar.gz'
  sha1 '4fb6c86740b2a6b71a9d22bb027729f0a9058bc3'

  head 'https://github.com/lmrodriguezr/nonpareil.git'

  depends_on 'r'
  depends_on :mpi => [:cxx, :optional]

  def install
    system "make", "nonpareil"
    system "make", "mpicpp=#{ENV['MPICXX']}", "nonpareil-mpi" if build.with? :mpi
    system "make", "prefix=#{prefix}", "mandir=#{man1}", "install"
    libexec.install "test/test.fasta"
  end

  test do
    system "nonpareil", "-s", "#{libexec}/test.fasta", "-b", "#{libexec}/test"
  end
end
