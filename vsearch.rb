class Vsearch < Formula
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.0.5.tar.gz"
  sha256 "13726a66a907d679e4a2ccbc9e7c9ec143542947bd8de7193cdf9d2ed524572a"
  head "https://github.com/torognes/vsearch.git"
  # doi "10.5281/zenodo.31443"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "dca5d11787cea6d50852e5d9645f3142bf8dac58e0f2d22e56a592e9428321c8" => :el_capitan
    sha256 "28d17c749ecdbd6f358fe9a033d620fd17eaece08df36d37d3615a464070b2b2" => :yosemite
    sha256 "267808a5e1ac1a723c04bb8fa9326b9d15ff4746a9a2aab0f64826eb213f0ca7" => :mavericks
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
