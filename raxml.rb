class Raxml < Formula
  homepage "http://sco.h-its.org/exelixis/web/software/raxml/index.html"
  url "https://github.com/stamatak/standard-RAxML/archive/v8.1.15.tar.gz"
  sha256 "f0388f6c5577006dc13e2dc8c35a2e5046394f61009ec5b04fb09254f8ec25b2"
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
