class Tbl2asn < Formula
  desc "Automates the submission of sequence records to GenBank"
  homepage "https://www.ncbi.nlm.nih.gov/genbank/tbl2asn2/"
  # tag "bioinformatics"

  # version number is in ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/DOCUMENTATION/VERSIONS
  version "25.3"
  if OS.mac?
    url "ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/mac.tbl2asn.gz"
    sha256 "429d63ee3c36d1f2f6322c62c6089d5ee8a8b089e5cc9373e298e017bcbbb9ec"
  elsif OS.linux?
    url "ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz"
    sha256 "37fb033ef3364447d718b726f234da124d474fa22a31917d3b60458ef8294283"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d1d425c14dac16911a3cd2f55968da21bea1519c305ebec58c2154ef330b4b4a" => :sierra
    sha256 "5e9baf2faa15d2a9e9eada81d4edcf09ea09e5e40952b44ed341e8e902980c8d" => :el_capitan
    sha256 "1afa149ee069a6e78b3f4c7305e1f361d44d2a97d93e7cd175e5744d44bbd70c" => :yosemite
    sha256 "2b8f4195c4a7facfe48fc86e4c58cad36431bdcd685568790dc2baaceb35c9e1" => :x86_64_linux
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
    assert_match "tbl2asn #{version}", shell_output("#{bin}/tbl2asn -")
  end
end
