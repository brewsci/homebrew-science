require "formula"

class Uproc < Formula
  homepage "http://uproc.gobics.de/"
  head "https://github.com/gobics/uproc.git"
  bottle do
    cellar :any
    sha256 "6e07dbb8062f34c6dbd5f550675371146f944579845ca172a54f9c6ba3c3a118" => :yosemite
    sha256 "134344cdc203c2cf27b452e7920bdfa8ed127d206c203e5f96d809cdb5ff521f" => :mavericks
    sha256 "e3396797b696c637784f3df6fab6435b0e5da41fa4cc002adee143092beae05a" => :mountain_lion
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
