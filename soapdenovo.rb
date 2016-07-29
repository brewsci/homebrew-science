class Soapdenovo < Formula
  desc "Next generation sequencing reads de novo assembler"
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
  revision 1

  head "https://github.com/aquaskyline/SOAPdenovo2.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "45eff6f4d00ab87723e56cd9a70266f1655dd348c90956a5638a9b342747aa36" => :el_capitan
    sha256 "36d4d5cf74c42109dc554d94a63043d092e1f7a2114870e5b58463d484546bfc" => :yosemite
    sha256 "61a15f82f4419cfd5f30e386ec73ebaefe2327ed364a6de77bdc813747f8ba25" => :mavericks
    sha256 "c8639f2fcfcdf1e26eb9a875ca413729aa0c4ee94ba6ebc553f6f7e97e19400e" => :x86_64_linux
  end

  # Fix undefined reference to `call_pregraph_sparse'
  # This patch is already applied upstream to the Mac tarball.
  patch do
    url "https://github.com/aquaskyline/SOAPdenovo2/pull/2.diff"
    sha256 "bce08407df9d28f972c9abe43c86d443dbb39164f27875fa535dc345b7fe5b18"
  end unless OS.mac?

  def install
    # Without deparallelize, you get a mishmash of 63-mer and 127-mer object files.
    ENV.deparallelize

    system "make"
    bin.install %w[SOAPdenovo-63mer SOAPdenovo-127mer]
    doc.install %w[LICENSE MANUAL VERSION]
  end

  test do
    system "#{bin}/SOAPdenovo-63mer"
    system "#{bin}/SOAPdenovo-127mer"
  end
end
