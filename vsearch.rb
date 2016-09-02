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
    sha256 "68d58acb86609f5869432fa9463b9295d4f66df383470da957841b6205320bd5" => :el_capitan
    sha256 "f80c70a4f8b9f9766d31223ef422e215d96f65451f6ae10206966649b000ba2a" => :yosemite
    sha256 "f2cc0f306663efd0301b977b6bb6960b17056f85b8ab046c260d898890a15b5b" => :mavericks
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
