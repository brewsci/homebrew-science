require 'formula'

class Nonpareil < Formula
  homepage 'http://enve-omics.ce.gatech.edu/nonpareil'
  url 'https://github.com/lmrodriguezr/nonpareil/archive/v2.4.tar.gz'
  sha1 '4fb6c86740b2a6b71a9d22bb027729f0a9058bc3'

  head 'https://github.com/lmrodriguezr/nonpareil.git'

  bottle do
    cellar :any
    sha1 "9fa1b02ccc8d561c9586b07d854c71227a77739e" => :yosemite
    sha1 "cd8a9999c84c41fc39aaa7f62cc1ab44a3a26300" => :mavericks
    sha1 "11adac7a92b44e5fd171bc1684a8b76fdceb848f" => :mountain_lion
  end

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
