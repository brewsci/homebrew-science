class Sortmerna < Formula
  desc "SortMeRNA: filter metatranscriptomic ribosomal RNA"
  homepage "http://bioinfo.lifl.fr/RNA/sortmerna/"
  # doi "10.1093/bioinformatics/bts611"
  # tag "bioinformatics"

  url "https://github.com/biocore/sortmerna/archive/2.0.tar.gz"
  sha256 "c0b1f7aab79ad26a195bc00e76c9a546d3c1542f51e4b72d5373efd04552e098"

  head "https://github.com/biocore/sortmerna.git"

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
