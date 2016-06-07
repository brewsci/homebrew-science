class Soapdenovo < Formula
  homepage "http://soap.genomics.org.cn/soapdenovo.html"
  # doi "10.1186/2047-217X-1-18"
  # tag "bioinformatics"

  if OS.mac?
    url "https://downloads.sourceforge.net/project/soapdenovo2/SOAPdenovo2/src/r240/SOAPdenovo2-src-r240-mac.tgz"
    sha256 "db7fbde57ddab0255d966f875f1d41e61a5cf8ad79e8d1c5411c79fc2cd062ce"
  else
    url "https://downloads.sourceforge.net/project/soapdenovo2/SOAPdenovo2/src/r240/SOAPdenovo2-src-r240.tgz"
    sha256 "b58fdb9b14766a122992d23dba5e91bd733c86e0062b432181aa5c1e7f052bb7"
  end
  version "2.04.r240"

  bottle do
    cellar :any
    sha256 "7405aab339c273e5384daf5e4b5022d326794b613a72a82e3dd51213f57e4d51" => :yosemite
    sha256 "5e50ec67bd196042344214132ba175648f8b4140f069245b79551a7d770565e2" => :mavericks
    sha256 "76c9e5c7ec9fb90ba94711b478a0b26a474fb91abff549d4efcaddc5120ba931" => :mountain_lion
    sha256 "9a0d92735144cf0a45f0817beb34c774a2171c39a8c9984c611f78ed8db33f1a" => :x86_64_linux
  end

  # Fix undefined reference to `call_pregraph_sparse'
  # This patch is already applied upstream to the Mac tarball.
  patch do
    url "https://github.com/aquaskyline/SOAPdenovo2/pull/2.diff"
    sha256 "bce08407df9d28f972c9abe43c86d443dbb39164f27875fa535dc345b7fe5b18"
  end unless OS.mac?

  def install
    system "make"
    bin.install %w[SOAPdenovo-63mer SOAPdenovo-127mer]
    doc.install %w[LICENSE MANUAL VERSION]
  end

  test do
    system "#{bin}/SOAPdenovo-63mer"
    system "#{bin}/SOAPdenovo-127mer"
  end
end
