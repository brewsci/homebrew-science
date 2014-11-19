require "formula"

class Kat < Formula
  homepage "https://github.com/TGAC/KAT"
  head "https://github.com/TGAC/KAT.git"
  #tag "bioinformatics"

  url "https://github.com/TGAC/KAT/releases/download/Release-1.0.6/kat-1.0.6.tar.gz"
  sha1 "845f59aebff01730247b6c8ecf8b1cf2d642b5da"

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gnuplot"
  depends_on "jellyfish-1.1"
  depends_on "seqan"

  def install
    ENV.libstdcxx if ENV.compiler == :clang && MacOS.version >= :mavericks
    inreplace "configure", "1.1.11", Formula["jellyfish-1.1"].version
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--with-jellyfish=#{Formula["jellyfish-1.1"].prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/kat --version"
  end
end
