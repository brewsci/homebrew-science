class Vsearch < Formula
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.3.3.tar.gz"
  sha256 "e2b25d89466172e6736c3a3ef19334ea75176938f83a406862257879153866b4"
  head "https://github.com/torognes/vsearch.git"
  # doi "10.5281/zenodo.31443"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "142115d8d5d196702bd397e99aeb934e713a542e7b4bbddab9a31207da87150f" => :sierra
    sha256 "142115d8d5d196702bd397e99aeb934e713a542e7b4bbddab9a31207da87150f" => :el_capitan
    sha256 "28d68c6cbac152e48c152d50a3dcfa46d34e08686336cbbc4d76b2d8a8c8b397" => :yosemite
    sha256 "d909383eb429c4accbb9e0c57fa59656cfa21808f32f5598ea6ff2a0ae8f3c5c" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "homebrew/dupes/zlib" unless OS.mac?
  depends_on "bzip2" unless OS.mac?

  def install
    system "./autogen.sh"
    system "./configure",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "allpairs_global", shell_output("#{bin}/vsearch --help 2>&1")
  end
end
