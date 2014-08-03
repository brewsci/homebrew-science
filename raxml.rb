require 'formula'

class Raxml < Formula
  homepage 'http://sco.h-its.org/exelixis/web/software/raxml/index.html'
  url 'https://github.com/stamatak/standard-RAxML/archive/v8.0.20.tar.gz'
  sha1 '91eaa19974eefc869ad60b5224a0c8c31c88795b'

  head 'https://github.com/stamatak/standard-RAxML.git'

  def install
    system "make", "-f", "Makefile.PTHREADS.gcc"
    (rm Dir["*.o"] and system "make", "-f", "Makefile.SSE3.PTHREADS.gcc") if Hardware::CPU.sse3?
    (rm Dir["*.o"] and system "make", "-f", "Makefile.AVX.PTHREADS.gcc") if Hardware::CPU.avx?
    bin.install Dir["raxmlHPC-*"]
  end

  test do
    system "raxmlHPC-PTHREADS", "-v"
  end
end
