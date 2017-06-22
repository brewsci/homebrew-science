class Gnuastro < Formula
  desc "Programs and libs for manipulation and analysis of astronomical data"
  homepage "https://www.gnu.org/software/gnuastro/index.html"
  url "https://ftp.gnu.org/gnu/gnuastro/gnuastro-0.3.tar.gz"
  sha256 "8a5bc2f977d4839f820d7423d10a6b94391a9571df97a64b9feb99a117973d81"
  revision 1

  bottle do
    sha256 "c3e6ffca6d2b06384b42ddcee53c23fe0d6823765bf4c5b6fd411b10ba19cfa7" => :sierra
    sha256 "279a30626c3c236f0ce1f14fb2f77dd3338cfcd5dc05e67858b52c06749deab6" => :el_capitan
    sha256 "62279cca6247ff8c6609b769e88c2b1e776116caa760097993daff43d609115c" => :yosemite
    sha256 "66293178d82284d4e37039e0a20175442b054541d1e3687b12334231cb6e7f51" => :x86_64_linux
  end

  depends_on "cfitsio"
  depends_on "gsl"
  depends_on "wcslib"
  depends_on "jpeg" unless OS.mac?

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-bin-op-alltypes",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/astarithmetic", "--help"
  end
end
