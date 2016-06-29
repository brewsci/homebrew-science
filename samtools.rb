class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "http://www.htslib.org/"
  # doi "10.1093/bioinformatics/btp352"
  # tag "bioinformatics"

  url "https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2"
  sha256 "6c3d74355e9cf2d9b2e1460273285d154107659efa36a155704b1e4358b7d67e"
  head "https://github.com/samtools/samtools.git"

  bottle do
    cellar :any
    sha256 "a00c0988740cfca3ab5c6320022e0be1040b388657e49392dda21991e0dd863d" => :el_capitan
    sha256 "7c0706b65c5675889a355c3d0ca544ff9f8f22e9401b7270c2a42486b780da99" => :yosemite
    sha256 "a7450a2071e194b8d53ca269279e875debce2167436b4e7d6e1cccb334a97f9f" => :mavericks
    sha256 "fb76b53c76435522541953727533afda8d95a848bc4c8754022c6c4e7c194dca" => :x86_64_linux
  end

  depends_on "htslib"
  depends_on "homebrew/dupes/ncurses" unless OS.mac?

  def install
    system "./configure", "--with-htslib=#{Formula["htslib"].opt_prefix}"
    system "make"

    bin.install Dir["{samtools,misc/*}"].select { |f| File.executable?(f) }
    lib.install "libbam.a"
    (include/"bam").install Dir["*.h"]
    man1.install "samtools.1"
    pkgshare.install "examples"
  end

  test do
    system bin/"samtools", "--help"
  end
end
