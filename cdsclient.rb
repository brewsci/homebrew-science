require 'formula'

class Cdsclient < Formula
  homepage 'http://cdsarc.u-strasbg.fr/doc/cdsclient.html'
  url 'http://cdsarc.u-strasbg.fr/ftp/pub/sw/cdsclient-3.71.tar.gz'
  sha1 '67639a1bb14f4ad5e48444950f42bcfa123af0a0'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    man.mkpath # --mandir not respected
    system "make", "install", "MANDIR=#{man}"
  end

  test do
    system 'findusnob1 -help 2>&1 | grep -q findusnob1'
  end
end
