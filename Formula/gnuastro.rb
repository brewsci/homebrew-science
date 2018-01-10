class Gnuastro < Formula
  desc "Programs and libs for manipulation and analysis of astronomical data"
  homepage "https://www.gnu.org/software/gnuastro/index.html"
  url "https://ftp.gnu.org/gnu/gnuastro/gnuastro-0.5.tar.gz"
  sha256 "19e385b2ae17395937c855c269028aedc39ba4daf9be86d790100c977dff9d82"

  bottle do
    sha256 "1bde26a005920b142fc665dbe056da4259a15d53694a0862b13257deb93468d1" => :high_sierra
    sha256 "e0fd88658cc25b0c82e93b85fbac8a2c38a291333cfc533d75946879b1ebeebf" => :sierra
    sha256 "446e651c43b315d2cb7728f4ebb2db6d2f9fd7500b7668bbe8bc733160225771" => :el_capitan
    sha256 "21871c4e3f038e393fac35404f19dd794f8de55bf585d40e978d9660038b0f7c" => :x86_64_linux
  end

  depends_on "cfitsio"
  depends_on "gsl"
  depends_on "wcslib"
  depends_on "jpeg" unless OS.mac?

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/astarithmetic", "--help"
  end
end
