require 'formula'

class Soapdenovo < Formula
  homepage 'http://soap.genomics.org.cn/soapdenovo.html'
  url 'http://soap.genomics.org.cn/down/SOAPdenovo-V1.05.src.tgz'
  sha1 'e7d8fc337de43cc6b96b2b24acbe5454cf0eadfe'

  def install
    system 'make all install'
    prefix.install 'LICENSE', 'MANUAL'
    bin.install Dir['bin/*']
  end

  test do
    system "#{bin}/SOAPdenovo-31mer"
  end
end
