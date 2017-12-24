class Vsearch < Formula
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.6.2.tar.gz"
  sha256 "65ffb5c368a07d7cdd24ed12ad53a4f81b840cc33539c1f963215488e0cb700a"
  head "https://github.com/torognes/vsearch.git"
  # doi "10.5281/zenodo.31443"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "91c7a10c4eb48f6268357cb5255bcbcb79f7f1de55aaa97c0811adbf7386ea18" => :high_sierra
    sha256 "b423ea6630de2badf1fa6c298b4388dd52698d2c3f1f6ff2da4a297e7ab7e8da" => :sierra
    sha256 "05c1c222cffedf76adb55946d961a3a0519927874b0d9198a67c7c227de3a913" => :el_capitan
    sha256 "76d63873e01cbf60ab735a54f733949ccd6ee1b5d393f6765b52ebafa4adf107" => :x86_64_linux
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
