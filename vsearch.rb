class Vsearch < Formula
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.2.0.tar.gz"
  sha256 "737ab66149b4c3690edcce0773f4c12619ca363bcc226e687cdd9009779dd92e"
  head "https://github.com/torognes/vsearch.git"
  # doi "10.5281/zenodo.31443"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b7f08d082ae563811e353b7b46d3ce1aa69cea2e210172eca0ed762fd7a0aaf" => :sierra
    sha256 "0b7f08d082ae563811e353b7b46d3ce1aa69cea2e210172eca0ed762fd7a0aaf" => :el_capitan
    sha256 "5d6fb7ed28f25192e3b04ccde7979214c92431b207a32b92120b15917fdb0a83" => :yosemite
    sha256 "f949d36e4cf8294516d3e2330e5b7d770f2fcc57e34ec22c90c85a31121eebd7" => :x86_64_linux
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
