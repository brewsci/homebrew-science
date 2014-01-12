require 'formula'

class Raxml < Formula
  homepage 'http://sco.h-its.org/exelixis/web/software/raxml/index.html'
  url 'https://github.com/stamatak/standard-RAxML/archive/v8.0.1.tar.gz'
  sha1 'ddfeea52f0e7e64e7165e6c030b2a7cea4be6c7a'

  head 'https://github.com/stamatak/standard-RAxML.git'

  def install
    system "make", "-f", "Makefile.SSE3.gcc"
    system "make", "-f", "Makefile.SSE3.PTHREADS.gcc"
    bin.install("raxmlHPC-SSE3", "raxmlHPC-PTHREADS-SSE3")
  end

  def test
    system "raxmlHPC-SSE3", "-v"
    system "raxmlHPC-PTHREADS-SSE3", "-v"
  end
end
