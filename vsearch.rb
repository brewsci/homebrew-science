class Vsearch < Formula
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.3.4.tar.gz"
  sha256 "5411ab85179b090e4c56415744e0e432b2fdbce2889d8f7aafc2740f6b57d9f7"
  head "https://github.com/torognes/vsearch.git"
  # doi "10.5281/zenodo.31443"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "36f333bd68c10a8beec38551d4f979aefd9bdf8132ce3503e50cac948950101d" => :sierra
    sha256 "36f333bd68c10a8beec38551d4f979aefd9bdf8132ce3503e50cac948950101d" => :el_capitan
    sha256 "e957e27351df20bded562671ff728d6e47d3380e258dea6259f23c853c88e23b" => :yosemite
    sha256 "b52fa8aa745b55e85e0656a2b17e96c65c4ac0bc1f12fd63c2d8d2092416bce8" => :x86_64_linux
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
