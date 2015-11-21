class Breseq < Formula
  desc "Find mutations in microbes from short reads"
  homepage "http://barricklab.org/twiki/bin/view/Lab/ToolsBacterialGenomeResequencing"
  # doi "10.1007/978-1-4939-0554-6_12"
  # tag "bioinformatics"

  url "https://github.com/barricklab/breseq/releases/download/v0.28.1/breseq-0.28.1.Source.tar.gz"
  sha256 "234e9c7fc45a88b9a005160a5b1247486eb00fcea2846d9091008208ea219aa0"

  head "https://github.com/barricklab/breseq.git"

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
