class Gnuastro < Formula
  desc "Programs and libs for manipulation and analysis of astronomical data"
  homepage "https://www.gnu.org/software/gnuastro/index.html"
  url "https://ftp.gnu.org/gnu/gnuastro/gnuastro-0.4.tar.gz"
  sha256 "3ac37879efcb14256b40d1d93eaad014cc056ecff62c30606131a137c9ff60d8"

  bottle do
    sha256 "79bb41747e566d0304acfa5a68903631860688ed2d2efb524a1a85f94d9e6738" => :high_sierra
    sha256 "95ddda94b32f8ace966e928dd83700267db2dacc90e549566aced945122c863d" => :sierra
    sha256 "9a14e64d1ebf72a1555fc5e403571144c8e1b0c1918d01794f667af28e983dcc" => :el_capitan
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
