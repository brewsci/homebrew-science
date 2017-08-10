class Gnuastro < Formula
  desc "Programs and libs for manipulation and analysis of astronomical data"
  homepage "https://www.gnu.org/software/gnuastro/index.html"
  url "https://ftp.gnu.org/gnu/gnuastro/gnuastro-0.3.tar.gz"
  sha256 "8a5bc2f977d4839f820d7423d10a6b94391a9571df97a64b9feb99a117973d81"
  revision 2

  bottle do
    sha256 "bbb6459d691af315bb88a402245119546ebc9a51f73ba0ee90d5c4e2621e572a" => :sierra
    sha256 "322576c30482e85b050add2c47a5e5bef055f38bf607bc47686c626102966148" => :el_capitan
    sha256 "75137093c09f3434ea91db08b7609babec9da4af979ff73562716814c9efbbd2" => :yosemite
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
