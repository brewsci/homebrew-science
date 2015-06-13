class Uproc < Formula
  desc "Ultra-fast protein sequence classification"
  homepage "http://uproc.gobics.de/"
  url "https://github.com/gobics/uproc/archive/1.2.0.tar.gz"
  sha256 "ceda51784fdce81791e5f669b08a20c415af476ac1ce29a59b596f1181de4f8e"
  head "https://github.com/gobics/uproc.git"
  # doi "10.1093/bioinformatics/btu843"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "6e07dbb8062f34c6dbd5f550675371146f944579845ca172a54f9c6ba3c3a118" => :yosemite
    sha256 "134344cdc203c2cf27b452e7920bdfa8ed127d206c203e5f96d809cdb5ff521f" => :mavericks
    sha256 "e3396797b696c637784f3df6fab6435b0e5da41fa4cc002adee143092beae05a" => :mountain_lion
    sha256 "3bba0f55550fe56b6b77fee676e6f75fc5969224b02cda66c7c76f5da88058d6" => :x86_64_linux
  end

  needs :openmp # => :recommended

  depends_on "doxygen" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fvi"
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--with-sysroot=#{HOMEBREW_PREFIX}",
      "--prefix=#{prefix}"

    # Patch for bug related to tar -o option: https://github.com/gobics/uproc/issues/12
    inreplace "libuproc/docs/Makefile", "chozf", "chzf"

    system "make", "install"
  end

  test do
    system "#{bin}/uproc-dna", "--version"
    system "#{bin}/uproc-prot", "--version"
  end
end
