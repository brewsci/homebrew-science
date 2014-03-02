require 'formula'

class Soapdenovo < Formula
  homepage 'http://soap.genomics.org.cn/soapdenovo.html'
  if OS.mac?
    url 'https://downloads.sourceforge.net/project/soapdenovo2/SOAPdenovo2/src/r240/SOAPdenovo2-src-r240-mac.tgz'
    sha1 '2ddefdb9f19076d43a9badadb9240d2ed333518b'
  else
    url 'https://downloads.sourceforge.net/project/soapdenovo2/SOAPdenovo2/src/r240/SOAPdenovo2-src-r240.tgz'
    sha1 'ca146c042b170b6a78f909dd9b3f1b1f051a08dc'
  end
  version '2.04-r240'

  def install
    system 'make'
    bin.install %w[SOAPdenovo-63mer SOAPdenovo-127mer]
    doc.install %w[LICENSE MANUAL VERSION]
  end

  test do
    system "#{bin}/SOAPdenovo-63mer"
    system "#{bin}/SOAPdenovo-127mer"
  end
end
