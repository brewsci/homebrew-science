class Jellyfish < Formula
  homepage "http://www.genome.umd.edu/jellyfish.html"
  #doi "10.1093/bioinformatics/btr011"
  #tag "bioinformatics"

  url "ftp://ftp.genome.umd.edu/pub/jellyfish/jellyfish-2.1.4.tar.gz"
  sha1 "37ddd37c1eb16031716f40c732516c30fbf37544"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "53dbef087576fc418756cc39332679f5e58b8fef" => :yosemite
    sha1 "4dc0a43a6c61044bef1822fb29481a4a6d19921e" => :mavericks
  end

  head do
    url "https://github.com/gmarcais/Jellyfish.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "yaggo" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jellyfish", "--version"
  end
end
