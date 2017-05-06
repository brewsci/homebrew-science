class Gnuastro < Formula
  desc "Programs and libs for manipulation and analysis of astronomical data"
  homepage "https://www.gnu.org/software/gnuastro/index.html"
  url "https://ftp.gnu.org/gnu/gnuastro/gnuastro-0.2.tar.gz"
  sha256 "3b26190d47dc2d3f1d00ab0799c9fec9ce9bfa931e2e4f924ff98587ff792901"

  bottle do
    sha256 "ede3ca24ee5c9c4edac3a1b9c714a50adbdc4741154a60d33bfa658ec85f91de" => :sierra
    sha256 "07ce8883c40f64db183a41b5559d38abce69b8ecf59127e80aefb13f644d1267" => :el_capitan
    sha256 "2b36e100d8e5fdaa20897ca91855f1f463f6db06df395df346bce3b610d509e9" => :yosemite
  end

  depends_on "cfitsio"
  depends_on "gsl"
  depends_on "wcslib"
  depends_on "jpeg" unless OS.mac?

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/astarithmetic", "--help"
  end
end
