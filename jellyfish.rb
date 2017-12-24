class Jellyfish < Formula
  desc "Fast, memory-efficient counting of DNA k-mers"
  homepage "http://www.genome.umd.edu/jellyfish.html"
  # doi "10.1093/bioinformatics/btr011"
  # tag "bioinformatics"

  url "https://github.com/gmarcais/Jellyfish/releases/download/v2.2.7/jellyfish-2.2.7.tar.gz"
  sha256 "d80420b4924aa0119353a5b704f923863abc802e94efeb531593147c13e631a8"

  bottle do
    cellar :any
    sha256 "6807736ebaa464357be5103292b7f1fb652473fefa94387b5a719beb9c384dae" => :high_sierra
    sha256 "4a90bfc83c017e42ec3595d60672a3a86b50a1082fcc7d57c33c598f57111cef" => :sierra
    sha256 "ed4da96fb98f98ee878062aa0394877db052b545e7deaf2788ccee8585bc973d" => :el_capitan
    sha256 "e445f98d08972ce12ae5a0c19758644307310ecd7419deeda27831affe5a2d34" => :x86_64_linux
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
