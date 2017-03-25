class Breseq < Formula
  desc "Find mutations in microbes from short reads"
  homepage "http://barricklab.org/twiki/bin/view/Lab/ToolsBacterialGenomeResequencing"
  url "https://github.com/barricklab/breseq/releases/download/v0.30.0/breseq-0.30.0-Source.tar.gz"
  sha256 "a5504a9bf7967a773ce28519ff4619c33f6b7f7efaf45ad8ed58273c5dea290d"
  head "https://github.com/barricklab/breseq.git"
  # doi "10.1007/978-1-4939-0554-6_12"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6617f4a6035dd722b869a5a0c68ba3db5cdaeb2f848c6e21543b3655d49813c" => :sierra
    sha256 "694d27222c7418bf3093ec45b1fe74a4235fab6da09c669ec3d96ce0a7c30eab" => :el_capitan
    sha256 "9fd77fef27a79d8cf3530814eba451ed226249c3204a583f326c8cd67ee2c99e" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "bowtie2"
  depends_on "r"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    assert_match "regardless", shell_output("#{bin}/breseq -h 2>&1", 255)
  end
end
