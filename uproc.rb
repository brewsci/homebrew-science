require "formula"

class Uproc < Formula
  homepage "http://uproc.gobics.de/"
  head "https://github.com/gobics/uproc.git"
  #tag "bioinformatics"

  url "http://uproc.gobics.de/downloads/uproc/uproc-1.1.2.tar.gz"
  sha1 "32acdf691001e93d3a00e5351fb876c6b71779a7"

  needs :openmp # => :recommended

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/uproc-dna", "--version"
  end
end
