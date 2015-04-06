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
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "d6267f0ee43987f34aec6b81027ea3bb847efbefad7de94ced009f3c58e76c8d" => :yosemite
    sha256 "da8bed566415973b70668dd970304db43e08629ab6c6323196d3516d85f6cc98" => :mavericks
    sha256 "47e97e133b2a477510985f6d882d9691028073052e2d7943c3d85658ded72ed1" => :mountain_lion
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
