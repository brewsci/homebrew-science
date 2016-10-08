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
    sha256 "c7fa2631560c853023b6baf4a9d48bb96e82a24b9c9a471d388fd0814d11bdc7" => :sierra
    sha256 "c7fa2631560c853023b6baf4a9d48bb96e82a24b9c9a471d388fd0814d11bdc7" => :el_capitan
    sha256 "bd362db32d09a8f67c137023c8a02252400092ebbd385097ee28b40f36986de4" => :yosemite
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
