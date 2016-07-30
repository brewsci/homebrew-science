class Vsearch < Formula
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.0.2.tar.gz"
  sha256 "dbafeb2621d61e0c47b467a3496dce9b98d8148218570d47f0d0c0bc857c93ac"
  head "https://github.com/torognes/vsearch.git"
  # doi "10.5281/zenodo.31443"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d4da172041f99da989ee7d626442df3bdd655db605daa5d0cfe65fcee0b1712" => :el_capitan
    sha256 "61761285488ded397ae8d6a1f71d7e19242d78704809b8f580123f42902f3344" => :yosemite
    sha256 "991791cffedfb5f86294e9c0bb96c483d0d63775885c9f767ceaa3daa4ba43be" => :mavericks
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
