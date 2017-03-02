class Vsearch < Formula
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.4.1.tar.gz"
  sha256 "0be48f24d75852788842a166efb8ef3bd4d07ae7c7ddb3c2179ec1961bc2d6de"
  head "https://github.com/torognes/vsearch.git"
  # doi "10.5281/zenodo.31443"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "28aa1ff8bfe2fac10b4dcd22222ef15f6a7b44466f122cdb3fcf88fd2f79bd06" => :sierra
    sha256 "28aa1ff8bfe2fac10b4dcd22222ef15f6a7b44466f122cdb3fcf88fd2f79bd06" => :el_capitan
    sha256 "d91b3bda2579749ba71471bfbf9517bced4e8f9566130f089af8c63c09258e3e" => :yosemite
    sha256 "41d71eb0d5e1fbed47672239c24d52f52aefba7416600d2237f5c6719a128373" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  unless OS.mac?
    depends_on "bzip2"
    depends_on "zlib"
  end

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
