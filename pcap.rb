class Pcap < Formula
  homepage "http://seq.cs.iastate.edu/pcap.html"
  if OS.mac?
    url "http://seq.cs.iastate.edu/PCAP/pcap.rep.osx.intel64.tar"
    sha256 "dcf4d59ba1226ebac0ac604af0eb9cee246742bbd7bce2fd36e115ed0335c014"
  elsif OS.linux?
    url "http://seq.cs.iastate.edu/PCAP/pcap.rep.linux.xeon64.tar"
    sha1 "fcc60a0f7f09926a278af1f0090aceae27c06fac"
  end
  version "2005-06-07"

  def install
    doc.install %w[README Distributed.doc Doc Doc.rep autopcap.doc]
    bin.install Dir["*"]
  end

  test do
    system "pcap 2>&1 |grep -q pcap"
  end
end
