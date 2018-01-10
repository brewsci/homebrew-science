class Breseq < Formula
  desc "Find mutations in microbes from short reads"
  homepage "http://barricklab.org/twiki/bin/view/Lab/ToolsBacterialGenomeResequencing"
  url "https://github.com/barricklab/breseq/releases/download/v0.31.1/breseq-0.31.1-Source.tar.gz"
  sha256 "52471eb1c90b1b564243ad6d1c668a82a5539ef742b0badbbb9c7b3fcc2afac3"
  head "https://github.com/barricklab/breseq.git"
  # doi "10.1007/978-1-4939-0554-6_12"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "3fa45e4b226bfea55434957def8d630c149e91beff1b28cf362a4864b5fa0b26" => :high_sierra
    sha256 "bea79c4ca40e7db8e11c6c7364bbd89999878ffde22f86d24592ca749660b99b" => :sierra
    sha256 "54fd05f58de2c6d0bb51c3ec6ac576ae0754d20466d0d0b2eb80c8092c6afea0" => :el_capitan
    sha256 "29e67d1437b040ff2589ebaa83fdd0c70c6c9c09089021e5b77e96e4154f0bb0" => :x86_64_linux
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
