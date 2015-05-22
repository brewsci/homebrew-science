class Tbl2asn < Formula
  homepage "https://www.ncbi.nlm.nih.gov/genbank/tbl2asn2/"
  # tag "bioinformatics"

  version "24.3"
  if OS.mac?
    url "ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/mac.tbl2asn.gz"
    sha256 "1e7052673a26a55cf710bad58245af3a2534358d368e2077a17fed8ff13bbc32"
  elsif OS.linux?
    url "ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz"
    sha256 "00265752e4b69f17e2e1066e42187bf0f65126ce3a2c6ac4bc2fd6ddae139163"
  end

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    revision 1
    sha256 "7334c59c85df90646a14652275e756c4726d4e58003f940d98bd5f9d582442d7" => :yosemite
    sha256 "3cccf7c5e9a3838417806595462c8923c84194dba5a65485c0beaaf2d85cf9da" => :mavericks
    sha256 "136ae8998d9a0d121445f3213374c260c6d0cc9c491df2af00afd9b724acd73a" => :mountain_lion
  end

  resource "doc" do
    url "ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/DOCUMENTATION/tbl2asn.txt"
    sha256 "b5e139c2a22cea4e1b5c7a063e3fb1f311d6b8802f2a8cca1433d7f16f816300"
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
