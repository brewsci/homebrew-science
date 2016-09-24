class Vsearch < Formula
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.1.1.tar.gz"
  sha256 "09d3ddad555ec513f2876bcb9858d988d9b3a67c752619729060bf3b6d04c466"
  head "https://github.com/torognes/vsearch.git"
  # doi "10.5281/zenodo.31443"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d33db0fcedcd4bfb73c9ad03682577f1d813f15184a3ace787590fb110df5bb" => :el_capitan
    sha256 "c5876af1dc80251f87a9718842194bd9651c6ce77272479a02884ad63fb4134c" => :yosemite
    sha256 "209be19232e5349378632da37049e2e315212230fc2a2351dab18bc342097903" => :mavericks
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
