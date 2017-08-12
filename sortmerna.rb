class Sortmerna < Formula
  desc "SortMeRNA: filter metatranscriptomic ribosomal RNA"
  homepage "http://bioinfo.lifl.fr/RNA/sortmerna/"
  # doi "10.1093/bioinformatics/bts611"
  # tag "bioinformatics"

  url "https://github.com/biocore/sortmerna/archive/2.1b.tar.gz"
  sha256 "b3d122776c323813971b35991cda21a2c2f3ce817daba68a4c4e09d4367c0abe"

  head "https://github.com/biocore/sortmerna.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ffe49e5a0ab921c53d034c4d4efc2b76cf73155b6b5257812be3f2729d7f56f" => :sierra
    sha256 "7a17df037fc24ef5c733e397f22c07f7fe0b2ed9186c072904e4c0414261aa91" => :el_capitan
    sha256 "a631cb5846ab986237852a6df657a08eb3d27a9ad4a84c841f4ab9a150812af4" => :yosemite
    sha256 "1960fbae3555d64678adae064c54f0107904655dabeae2790e4eac7869c8bde9" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/sortmerna", "--version"
  end
end
