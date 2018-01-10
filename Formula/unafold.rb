class Unafold < Formula
  homepage "http://mfold.rna.albany.edu/"
  url "http://mfold.rna.albany.edu/cgi-bin/UNAFold-download.cgi?unafold-3.8.tar.gz"
  sha256 "48d287126a6060729a00da7e6190a4a171a79876a0023b98bb1830cb460758ff"

  depends_on "gd"
  depends_on "gnuplot"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
