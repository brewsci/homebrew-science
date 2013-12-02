require 'formula'

class Sllib < Formula
  homepage 'http://www.ir.isas.jaxa.jp/~cyamauch/sli/index.html'
  url 'http://www.ir.isas.jaxa.jp/~cyamauch/sli/sllib-1.4.2f.tar.gz'
  sha1 '41c71ca93cab0552f9edcc6e46917aa26e7121dc'

  def install
    system "sh", "configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
