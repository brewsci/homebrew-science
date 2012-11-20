require 'formula'

class Infernal < Formula
  homepage 'http://infernal.janelia.org/'
  url 'ftp://selab.janelia.org/pub/software/infernal/infernal-1.1rc1.tar.gz'
  sha1 '89077437c53d36fac37ba1e677ce05c112cd7588'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    system "cmsearch", "-h"
  end
end
