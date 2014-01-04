require 'formula'

class Infernal < Formula
  homepage 'http://infernal.janelia.org/'
  url 'http://selab.janelia.org/software/infernal/infernal-1.1.tar.gz'
  sha1 'b3bd2659fdda1c1af35c3b3e40f61fcdac23c3a3'

  option 'check', 'Run the test suite (`make check`). Takes a couple of minutes.'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make check" if build.include? 'check'
    system "make install"
  end

  def test
    system "cmsearch", "-h"
  end
end
