class Gnuastro < Formula
  desc "Programs and libs for manipulation and analysis of astronomical data"
  homepage "https://www.gnu.org/software/gnuastro/index.html"
  url "https://ftp.gnu.org/gnu/gnuastro/gnuastro-0.3.tar.gz"
  sha256 "8a5bc2f977d4839f820d7423d10a6b94391a9571df97a64b9feb99a117973d81"
  revision 1

  bottle do
    sha256 "c5d68842386eafb97a282d409052683bf1a2b86ddabcbb0cfdd6467850f2248b" => :sierra
    sha256 "9496f71903f53f64d1633709d64e0231f7772ded8ba2e75a629d3f3a3c5ea120" => :el_capitan
    sha256 "3e236f37762dd8311abc07353325c861316d6778d1cf33e1b5822a11e35feb9e" => :yosemite
    sha256 "f8983b5207a75cb27cbf676937ebb5f03dc7821229c7c072d1a27df092808481" => :x86_64_linux
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
