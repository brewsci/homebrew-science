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
    sha256 "ee75300a501ab2c6f376697830940b68ef6ee22fd86f5483b8b49331f30bd842" => :el_capitan
    sha256 "b41384be8f1b5dc2c15f3f656cd1ccbe30d743e0ca5a7ca05e9a1964eeddcc31" => :yosemite
    sha256 "561d4e98f7f1804fd18940c50490c46a6b70b61e10208778b6b4cbd9aa7767c2" => :mavericks
  end

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
