require 'formula'

class Nonpareil < Formula
  homepage 'http://enve-omics.ce.gatech.edu/nonpareil'
  url 'https://github.com/lmrodriguezr/nonpareil/archive/v2.302.tar.gz'
  sha1 '14e3cd8bafcbf5bb91e6fb3cf5ef6ed7a550c0e0'

  head 'https://github.com/lmrodriguezr/nonpareil.git'

  depends_on 'r'
  depends_on :mpi => [:cxx, :optional]

  def install
    system "make", "nonpareil"
    system "make", "mpicpp=#{ENV['MPICXX']}", "nonpareil-mpi" if build.with? :mpi
    system "make", "prefix=#{prefix}", "mandir=#{man1}", "install"
  end

  test do
    system "nonpareil", "-V"
    system "nonpareil-mpi", "-V" if build.with? 'open-mpi'
  end
end
