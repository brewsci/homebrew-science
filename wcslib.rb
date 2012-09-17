require 'formula'

class Wcslib < Formula
  homepage 'http://www.atnf.csiro.au/people/mcalabre/WCS/'
  url 'ftp://ftp.atnf.csiro.au/pub/software/wcslib/wcslib-4.14.tar.bz2'
  sha1 '8c530c29866ca3414f62d27f439b3d5e6dcb39a1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.deparallelize
    system "make"
    system "make install"
  end
end
