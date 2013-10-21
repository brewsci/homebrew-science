require 'formula'

class Pcap < Formula
  homepage 'http://seq.cs.iastate.edu/pcap.html'
  if OS.mac? then
    url 'http://seq.cs.iastate.edu/PCAP/pcap.rep.osx.intel64.tar'
    sha1 'd8bffe625e84fc6de627a283b83c105b943e36c3'
  elsif OS.linux? then
    url 'http://seq.cs.iastate.edu/PCAP/pcap.rep.linux.xeon64.tar'
    sha1 'fcc60a0f7f09926a278af1f0090aceae27c06fac'
  end
  version '2005-06-07'

  def install
    doc.install %w[README Distributed.doc Doc Doc.rep autopcap.doc]
    bin.install Dir['*']
  end

  test do
    system 'pcap 2>&1 |grep -q pcap'
  end
end
