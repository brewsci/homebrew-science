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
    sha256 "84942c4318844bfacdbfc33370a8fe6ad1859c75feb8946c5fa69364d5c19818" => :sierra
    sha256 "a54cbe501eaa172add6b2f904351de3a6bc6723e4276d52d263a1b53faa1d478" => :el_capitan
    sha256 "78ddecfe3acf637d3cd06285dd3551ec929e5b6e593fe5e03c274ebebcdaac41" => :yosemite
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
