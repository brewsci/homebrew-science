require 'formula'

class Niftilib < Formula
  homepage 'http://niftilib.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/niftilib/nifticlib/nifticlib_2_0_0/nifticlib-2.0.0.tar.gz'
  sha1 '3a6187cb09767f97cef997cf492d89ac3db211df'

  def install
    ENV.deparallelize
    system "make"
    bin.install Dir['bin/*']
    lib.install Dir['lib/*']
    include.install Dir['include/*']
  end
end
