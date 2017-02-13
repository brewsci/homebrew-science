class Jellyfish < Formula
  desc "Fast, memory-efficient counting of DNA k-mers"
  homepage "http://www.genome.umd.edu/jellyfish.html"
  # doi "10.1093/bioinformatics/btr011"
  # tag "bioinformatics"

  url "https://github.com/gmarcais/Jellyfish/releases/download/v2.2.6/jellyfish-2.2.6.tar.gz"
  sha256 "4532fb003a0494f6473bb97d52467904f631b94f7f9afb0d45b398f6c413692e"

  bottle do
    cellar :any
    sha256 "049f8c9ef83d50316ab48e2833802231bed433e4819184c857b7b1f58649db32" => :sierra
    sha256 "4cd8f5c06f7a0363a6fb0eccac6b98c2313eed960877758db994ceba434a7a1c" => :el_capitan
    sha256 "7cab6af560dba76d8dced0d0f082db78600413a61bc223cf817f28021ed573f9" => :yosemite
    sha256 "381dcbf181c66cd3692ead8e1a8748f73227d54b2755618f2b45e526509a5397" => :x86_64_linux
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
