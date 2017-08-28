class Vsearch < Formula
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.4.4.tar.gz"
  sha256 "13909f188d0e0ddb24a845e3d8d60afe965751e800659ae729bb61c5e5230ab5"
  head "https://github.com/torognes/vsearch.git"
  # doi "10.5281/zenodo.31443"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "73683bf339c36c4b845265c9a7f6daa9b8d5c3e7889038fdf8273d66fe1962ac" => :sierra
    sha256 "a045d20921761ca0204bc937b0ecea319d2bba361e0e3f6a356cf9a352c4ea42" => :el_capitan
    sha256 "cb91518460473f6092772b55084662edd88e0e87385e1eea817cd12782e0ce77" => :yosemite
    sha256 "58038df3f6450cec2c22034f42ce982ba53c0a7289f5b2164b9bba44b84dace2" => :x86_64_linux
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
