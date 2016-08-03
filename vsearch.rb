class Vsearch < Formula
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.0.3.tar.gz"
  sha256 "e8f773f4a3b3441a32c3ae8cfe8d9ef10403f5344f4add669e9b817c94b4b395"
  head "https://github.com/torognes/vsearch.git"
  # doi "10.5281/zenodo.31443"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d4da172041f99da989ee7d626442df3bdd655db605daa5d0cfe65fcee0b1712" => :el_capitan
    sha256 "61761285488ded397ae8d6a1f71d7e19242d78704809b8f580123f42902f3344" => :yosemite
    sha256 "991791cffedfb5f86294e9c0bb96c483d0d63775885c9f767ceaa3daa4ba43be" => :mavericks
    sha256 "0507f5ded269319a9694f97637db1abf8d948311752bdbc8998d595460811473" => :x86_64_linux
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
