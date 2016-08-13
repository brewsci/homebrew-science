class Tbl2asn < Formula
  desc "Automates the submission of sequence records to GenBank"
  homepage "https://www.ncbi.nlm.nih.gov/genbank/tbl2asn2/"
  # tag "bioinformatics"

  # version number is in ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/DOCUMENTATION/VERSIONS
  version "25.0"
  if OS.mac?
    url "ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/mac.tbl2asn.gz"
    sha256 "d18785994de6e20e7f3502aa042b59817eaf58365b11e2b32b95856bc4738ec1"
  elsif OS.linux?
    url "ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz"
    sha256 "0f95c6c2872b2beb908eb42a64b15ed282424332faab3c442b43fc8b99548e58"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "46ee9b013b621f4853dc3c07f5d5289b083eb500e9609ab87ce0ef204973d8ed" => :el_capitan
    sha256 "fe9d754a97c7e313fee8e0ac0883dd635645dd9eea44f4da3dac4047669b2b6c" => :yosemite
    sha256 "4c12f59c562e6153ef2f34cead09a5331b15296be16423347ae9d4a9c1d826f9" => :mavericks
    sha256 "de337431a34cf93ed60a47b4327022452202c9ba648584b07edfdfaa8786c284" => :x86_64_linux
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
    assert_match "tbl2asn #{version}", shell_output("tbl2asn -")
  end
end
