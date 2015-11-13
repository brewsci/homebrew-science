class Vsearch < Formula
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"
  # tag "bioinformatics"
  # doi "10.5281/zenodo.31443"

  url "https://github.com/torognes/vsearch/archive/v1.9.1.tar.gz"
  sha256 "418065c9b361b033d9481064e46e8a29094e3df5edcb6ca2509bcdbedd331954"

  head "https://github.com/torognes/vsearch.git"

  depends_on "homebrew/dupes/zlib" => :recommended
  depends_on "bzip2" => :recommended

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "allpairs_global", shell_output("vsearch --help 2>&1")
  end
end
