class Jellyfish < Formula
  homepage "http://www.genome.umd.edu/jellyfish.html"
  #doi "10.1093/bioinformatics/btr011"
  #tag "bioinformatics"

  url "ftp://ftp.genome.umd.edu/pub/jellyfish/jellyfish-2.1.4.tar.gz"
  sha1 "37ddd37c1eb16031716f40c732516c30fbf37544"

  bottle do
    cellar :any
    sha256 "75f57f9a63419534a599fcbdd10ab713f675dc7f37a756afccde8162248cb3c9" => :yosemite
    sha256 "988ccb01c6684d250833bc7f0d9efada791675b352138e615b74eb3817bd8f14" => :mavericks
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
