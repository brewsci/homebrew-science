class Sllib < Formula
  homepage "http://www.ir.isas.jaxa.jp/~cyamauch/sli/index.html"
  url "http://www.ir.isas.jaxa.jp/~cyamauch/sli/sllib-1.4.2f.tar.gz"
  sha256 "dfd14039387db26c27c1895c6dd8ad8035f9166fcd005ddcae8632ee211666dc"

  def install
    system "sh", "configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
