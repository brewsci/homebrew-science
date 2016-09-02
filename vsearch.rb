class Vsearch < Formula
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.0.4.tar.gz"
  sha256 "f33d527259b93f9ade594800525438ba3ec376e80883e2635c82b32433ac1165"
  head "https://github.com/torognes/vsearch.git"
  # doi "10.5281/zenodo.31443"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "19f4b838dd3be869dd58fe07a98732fcdf47349faf7b50d0f4ed88b480b5fa30" => :el_capitan
    sha256 "c8f7df7c5901034eb5205654dc88490af37de02429bdc093be6b254233f831b2" => :yosemite
    sha256 "e50642508e42b108cab7c36aa79d8d5b75ad8814e6e30fe3c33f448ce478e158" => :mavericks
    sha256 "b7ff99c40b09b1de4639bd4a37395451a6da5b417b963477b6c9bc39086d1ff7" => :x86_64_linux
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
