class Unicycler < Formula
  desc "Hybrid assembly pipeline for bacterial genomes"
  homepage "https://github.com/rrwick/Unicycler"
  url "https://github.com/rrwick/Unicycler/archive/v0.4.2.tar.gz"
  sha256 "58dbeee3b829e00a6f53ea0a151fd6dc77f1a7c35fefa31602deb2f1f5f481ea"
  head "https://github.com/rrwick/Unicycler/releases"
  # doi "10.1371/journal.pcbi.1005595"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "84b4dbac901c6a9e1e1fd6153b3f3cbd6530d434b53206c926351223c4431525" => :sierra
    sha256 "5fd4d10e7ba577aec25d0f2984cea31b1f98eed6a49e4b21c77edaaea2a3e952" => :el_capitan
    sha256 "0a7d12716f60d234b8c4352c14bf3cd4895524fa9d6e4565f61e169dd7a3e91f" => :yosemite
    sha256 "39628dfc7b34305ee8bd69c0e70f264f7fc3b49f9b7efe5a28f919fd884eede9" => :x86_64_linux
  end

  needs :cxx14

  depends_on :python3
  depends_on "blast"
  depends_on "bowtie2"
  depends_on "pilon"
  depends_on "racon"
  depends_on "samtools"
  depends_on "spades"

  def install
    system "python3", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    assert_match "usage", shell_output("#{bin}/unicycler --help")
  end
end
