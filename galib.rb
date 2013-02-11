require 'formula'

class Galib < Formula
  homepage 'http://lancet.mit.edu/ga/'
  url 'http://lancet.mit.edu/ga/dist/galib247.tgz'
  sha1 '3411da19d6b5b67638eddc4ccfab37a287853541'

  def install
    ENV.deparallelize
    system "make"
    system "make test"
    system "make DESTDIR=#{prefix} install"
  end
end
