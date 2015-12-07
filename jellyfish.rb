class Jellyfish < Formula
  desc "Fast, memory-efficient counting of DNA k-mers"
  homepage "http://www.genome.umd.edu/jellyfish.html"
  # doi "10.1093/bioinformatics/btr011"
  # tag "bioinformatics"

  url "https://github.com/gmarcais/Jellyfish/releases/download/v2.2.4/jellyfish-2.2.4.tar.gz"
  sha256 "d31a71477c638caaeeacbede644870a7be26aa786919f4dd722b0a8fadb7dd28"

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
