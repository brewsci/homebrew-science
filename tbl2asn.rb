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
    sha256 "272ee59c3e42c288db111238b976eb25a28c14f24a4a3e09f62f7e8614d80c8e" => :el_capitan
    sha256 "ecc8f607eb078ae3f32a771c28551071c12ab62723321e4502fb47866451275a" => :yosemite
    sha256 "b6454c75f3b57c670628cfb11992abf3147427f9d9041815ee4810f91a57e84b" => :mavericks
    sha256 "425c92a150624e18f43f981b388fd17d53a765432dd23f40f3fdf67861626608" => :x86_64_linux
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
