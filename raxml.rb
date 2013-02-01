require 'formula'

class Raxml < Formula
  homepage 'http://sco.h-its.org/exelixis/software.html'
  url 'http://sco.h-its.org/exelixis/countSource728.php'
  version '7.2.8-alpha'
  sha1 '06088d8db5e66193604b6837cb1aec226895aa58'

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
