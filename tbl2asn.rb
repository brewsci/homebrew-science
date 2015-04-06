class Tbl2asn < Formula
  homepage "https://www.ncbi.nlm.nih.gov/genbank/tbl2asn2/"
  #tag "bioinformatics"

  version "24.2"
  if OS.mac?
    url "ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/mac.tbl2asn.gz"
    sha256 "c8c307b11d4089ad2a368d1ff1a1ce94dc0c40993478a233bc3331ef3f37ff00"
  elsif OS.linux?
    url "ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz"
    sha256 "a5fe31cfa37e5de1f7e4d971f294ad2ca2be9868f5591477fcfb2862668d04c7"
  end

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "fc5c56b3791194cfdf272b90b0735180e9d33b88" => :yosemite
    sha1 "39d37f0daead4cf2bf6e3184987f3072e569af0a" => :mavericks
    sha1 "143d56cb341b6db292d156f2f85c819e3ac240d3" => :mountain_lion
  end

  resource "doc" do
    url "ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/DOCUMENTATION/tbl2asn.txt"
    sha256 "f2da249ee8d60b385a8e71b67b480bff9c6d905a9d674e035c1186ce40a4f5c7"
  end

  def install
    if OS.mac?
      bin.install "mac.tbl2asn" => "tbl2asn"
    elsif OS.linux?
      bin.install "linux64.tbl2asn" => "tbl2asn"
    end
    doc.install resource("doc")
  end

  test do
    assert_match "tbl2asn #{version}", shell_output("tbl2asn -", 0)
  end
end
