class Vsearch < Formula
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.3.2.tar.gz"
  sha256 "82f523ca697ba5fb78ca84cea5ba0a2cffc7df5d9ab0d72ae72ead441ac2362e"
  head "https://github.com/torognes/vsearch.git"
  # doi "10.5281/zenodo.31443"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "33711908c87eab5df64067ec280139b4cd6894c66b65c5943dc49a70e3bfb19d" => :sierra
    sha256 "33711908c87eab5df64067ec280139b4cd6894c66b65c5943dc49a70e3bfb19d" => :el_capitan
    sha256 "46a0ee97cb0cb2b7b352863c364f57f4f78a9fcd18ae125b13ef6c5f8dfebf81" => :yosemite
    sha256 "9183fd46bdf8b713e5bcab16470bd35f0ec8c8b7dc65fecb35a2951bcb7b8bc9" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "homebrew/dupes/zlib" unless OS.mac?
  depends_on "bzip2" unless OS.mac?

  resource "manual" do
    url "https://github.com/torognes/vsearch/releases/download/v2.3.2/vsearch_manual.pdf"
    version "2.3.2"
    sha256 "f5a0cdaafb533535c43f09abec0e083d2c8d1af105c0057a4503dec7251ce040"
  end

  def install
    system "./autogen.sh"
    system "./configure",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make", "install"
    doc.install resource("manual")
  end

  test do
    assert_match "allpairs_global", shell_output("#{bin}/vsearch --help 2>&1")
  end
end
