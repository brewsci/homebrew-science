class Vsearch < Formula
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"
  bottle do
    cellar :any_skip_relocation
    sha256 "c2e3b55f92f61cf9f9adc4daa1c2aa718b37b77d66d098b1a888705049664b16" => :el_capitan
    sha256 "cbd33e469676ce6bd1a82252423421ab8369fbc3024804c739390b908957fae9" => :yosemite
    sha256 "edadfd2741c8f3c4add51c4104052fa425754292d90d66db3a824f21c1610d37" => :mavericks
    sha256 "720032f69cd5ec2153200dc3d30a196026b35ee0bc3008fb80a836f4ac976029" => :x86_64_linux
  end

  # tag "bioinformatics"
  # doi "10.5281/zenodo.31443"

  url "https://github.com/torognes/vsearch/archive/v1.9.1.tar.gz"
  sha256 "418065c9b361b033d9481064e46e8a29094e3df5edcb6ca2509bcdbedd331954"

  head "https://github.com/torognes/vsearch.git"

  depends_on "homebrew/dupes/zlib" => :recommended
  depends_on "bzip2" => :recommended

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "allpairs_global", shell_output("vsearch --help 2>&1")
  end
end
