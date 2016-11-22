class EMem < Formula
  desc "Efficiently compute MEMs between large genomes"
  homepage "http://www.csd.uwo.ca/~ilie/E-MEM/"
  url "http://www.csd.uwo.ca/~ilie/E-MEM/e-mem.zip"
  version "1.0.0"
  sha256 "dccf8f3fdd397a7ff370593e2efe9fe060d194cf1b279d835502f9008ca34632"
  # doi "10.1093/bioinformatics/btu687"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "b67ed6d5687530d9e86570e6e65164a3358ffe785771a10caad77627444f1d1f" => :sierra
    sha256 "fbd2e31ea4b9b8679fdde1c9ed5936fa3f17f3840270184db11f49979f4bed0f" => :el_capitan
    sha256 "95f69f5b0fd8b4f0fe0e437d4ee985c8a4bdc1bc8b0ed793cdbe5519db863066" => :yosemite
    sha256 "531f0d557ac8c858906639812dbbf1c53ba813a78cbc964686f5941d78ca3737" => :x86_64_linux
  end

  needs :openmp
  depends_on "boost" => :build

  def install
    cd "e-mem_2"
    system "make"
    bin.install "e-mem"
    prefix.install_metafiles
    prefix.install "example"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/e-mem --help")
  end
end
