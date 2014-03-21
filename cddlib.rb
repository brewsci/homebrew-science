require 'formula'

class Cddlib < Formula
  homepage 'http://www.inf.ethz.ch/personal/fukudak/cdd_home/'
  url 'ftp://ftp.ifor.math.ethz.ch/pub/fukuda/cdd/cddlib-094g.tar.gz'
  mirror 'http://www.mirrorservice.org/sites/distfiles.finkmirrors.net/cddlib-094g.tar.gz'
  sha1 '4ef38ca6efbf3d54a7a753c63ff25a8c95e5fc5f'

  depends_on 'gmp'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install Dir['doc/*']
    share.install Dir['examples*']
  end

end
