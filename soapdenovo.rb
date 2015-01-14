class Soapdenovo < Formula
  homepage "http://soap.genomics.org.cn/soapdenovo.html"
  #doi "10.1186/2047-217X-1-18"
  #tag "bioinformatics"

  if OS.mac?
    url "https://downloads.sourceforge.net/project/soapdenovo2/SOAPdenovo2/src/r240/SOAPdenovo2-src-r240-mac.tgz"
    sha1 "2ddefdb9f19076d43a9badadb9240d2ed333518b"
  else
    url "https://downloads.sourceforge.net/project/soapdenovo2/SOAPdenovo2/src/r240/SOAPdenovo2-src-r240.tgz"
    sha1 "ca146c042b170b6a78f909dd9b3f1b1f051a08dc"
  end
  version "2.04.r240"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "a7a895850e20c67f85cb5691902805653de54690" => :yosemite
    sha1 "08865280b912d9faec1447a6ef3442612807ddac" => :mavericks
    sha1 "b42f2e0414e808fff93aa8c820ae5069cb2fef57" => :mountain_lion
  end

  # Fix undefined reference to `call_pregraph_sparse'
  # This patch is already applied upstream to the Mac tarball.
  patch do
    url "https://github.com/aquaskyline/SOAPdenovo2/pull/2.diff"
    sha1 "d76eb26f9fbcb6333152a5cee6c060ebf91e42f3"
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
