require "formula"

class Uproc < Formula
  homepage "http://uproc.gobics.de/"
  head "https://github.com/gobics/uproc.git"
  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "e85ca47439010ba2bbed0676569516018647b12d" => :yosemite
    sha1 "a6d9496f7271755e9104ad7fa4af59476b982815" => :mavericks
    sha1 "6216fa194d8413b905d58b94993abb2eac531b48" => :mountain_lion
  end

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
