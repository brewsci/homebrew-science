class Raxml < Formula
  homepage "http://sco.h-its.org/exelixis/web/software/raxml/index.html"
  url "https://github.com/stamatak/standard-RAxML/archive/v8.1.15.tar.gz"
  sha1 "6bc3ba99788d59be197ffb949daf85ba0f1b2860"
  head "https://github.com/stamatak/standard-RAxML.git"

  def install
    system "make", "-f", "Makefile.PTHREADS.gcc"

    if Hardware::CPU.sse3?
      rm Dir["*.o"]
      system "make", "-f", "Makefile.SSE3.PTHREADS.gcc"
    end
    if Hardware::CPU.avx?
      rm Dir["*.o"]
      system "make", "-f", "Makefile.AVX.PTHREADS.gcc"
    end

    bin.install Dir["raxmlHPC-*"]
  end

  test do
    system "raxmlHPC-PTHREADS", "-v"
  end
end
