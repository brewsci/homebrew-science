class Diamond < Formula
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "http://www-ab.informatik.uni-tuebingen.de/data/software/diamond/download/public/diamond.tar.gz"
  version "0.7.1"
  sha256 "3f46c4c96a81d84dee23e82154d17330e33dd557c6a955f59cf1913acac1f110"

  # Fix fatal error: 'omp.h' file not found
  needs :openmp

  depends_on "boost"

  def install
    # Fix error: ld: library not found for -lrt
    inreplace "Makefile.in", " -lrt ", " " if OS.mac?

    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/diamond", "-h"
  end
end
