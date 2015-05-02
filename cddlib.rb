class Cddlib < Formula
  homepage "http://www.inf.ethz.ch/personal/fukudak/cdd_home/"
  url "ftp://ftp.ifor.math.ethz.ch/pub/fukuda/cdd/cddlib-094g.tar.gz"
  mirror "http://www.mirrorservice.org/sites/distfiles.finkmirrors.net/cddlib-094g.tar.gz"
  sha256 "af1b81226514abf731800e2e104def8a7274817d7e645693f8b99fc2b1432155"

  depends_on "gmp"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install Dir["doc/*"]
    (share/"cddlib").install Dir["examples*"]
  end
end
