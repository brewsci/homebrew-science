class Uproc < Formula
  homepage "http://uproc.gobics.de/"
  head "https://github.com/gobics/uproc.git"
  bottle do
    cellar :any
    sha256 "6e07dbb8062f34c6dbd5f550675371146f944579845ca172a54f9c6ba3c3a118" => :yosemite
    sha256 "134344cdc203c2cf27b452e7920bdfa8ed127d206c203e5f96d809cdb5ff521f" => :mavericks
    sha256 "e3396797b696c637784f3df6fab6435b0e5da41fa4cc002adee143092beae05a" => :mountain_lion
    sha256 "3bba0f55550fe56b6b77fee676e6f75fc5969224b02cda66c7c76f5da88058d6" => :x86_64_linux
  end

  # tag "bioinformatics"

  url "http://uproc.gobics.de/downloads/uproc/uproc-1.1.2.tar.gz"
  sha256 "062898c2a9c14db39ba057a4168c0efcf2a7c651e47b9c98863d8ab6afe6b1ac"

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
