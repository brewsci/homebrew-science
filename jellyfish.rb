class Jellyfish < Formula
  desc "Fast, memory-efficient counting of DNA k-mers"
  homepage "http://www.genome.umd.edu/jellyfish.html"
  # doi "10.1093/bioinformatics/btr011"
  # tag "bioinformatics"

  url "https://github.com/gmarcais/Jellyfish/releases/download/v2.2.4/jellyfish-2.2.4.tar.gz"
  sha256 "d31a71477c638caaeeacbede644870a7be26aa786919f4dd722b0a8fadb7dd28"

  bottle do
    cellar :any
    sha256 "634c642f093e0dad9112b527588a87a6313fb2cb12ce3c09ce67f4f749d373d1" => :el_capitan
    sha256 "5be96154d0ee630a904748790afb65316ac65744473b4d71e0f7a3e65e9d55c5" => :yosemite
    sha256 "02dacc8d217f7d281723a829b26cb4c5458e2796c8d9ea343bfd5efa40844785" => :mavericks
    sha256 "3bf6d0e34823ffac8e9e41d0b155561a600e68e46449ae609a393499f3c22969" => :x86_64_linux
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
