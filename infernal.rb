require 'formula'

class Infernal < Formula
  homepage 'http://infernal.janelia.org/'
  #doi "10.1093/bioinformatics/btp157"

  url 'http://selab.janelia.org/software/infernal/infernal-1.1.1.tar.gz'
  sha1 'b83fbc3a50c49ad51e40b37195aeacec94897d30'

  option 'check', 'Run the test suite (`make check`). Takes a couple of minutes.'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make check" if build.include? 'check'
    system "make install"
  end

  test do
    system "cmsearch", "-h"
  end
end
