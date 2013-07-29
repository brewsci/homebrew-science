require 'formula'

class Seqan < Formula
  homepage 'http://www.seqan.de/'
  url 'http://packages.seqan.de/seqan-library/seqan-library-1.4.1.tar.bz2'
  sha1 'a7d33813d34f999015e4f27bb398255436b202b2'
  head 'http://svn.seqan.de/seqan/trunk/core'

  def install
    include.install 'include/seqan'
    doc.install Dir['share/doc/seqan/*'] unless build.head?
  end
end
