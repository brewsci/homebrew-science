class Vsearch < Formula
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.1.2.tar.gz"
  sha256 "a8b01fbd7c6a694993c32ac41a77188e098deeb51373cab597f43bddbc91eeff"
  head "https://github.com/torognes/vsearch.git"
  # doi "10.5281/zenodo.31443"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "e24b2e2d33086bde2d3009e100cec27e605676f3718b40a4345eeb93234afdeb" => :sierra
    sha256 "e24b2e2d33086bde2d3009e100cec27e605676f3718b40a4345eeb93234afdeb" => :el_capitan
    sha256 "ef8371eee9bd57d9a6709509a85ccec3c264413b900e0739e23d7b2d54c974af" => :yosemite
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
