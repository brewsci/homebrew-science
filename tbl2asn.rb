require "formula"

class Tbl2asn < Formula
  homepage "https://www.ncbi.nlm.nih.gov/genbank/tbl2asn2/"
  version "23.0"
  if OS.mac?
    url "ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/mac.tbl2asn.gz"
    sha1 "2a38b87caf876d5d1a28382078ccb80cece861e3"
  elsif OS.linux?
    url "ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz"
    sha1 "7508df69771376e0f4e1309848fb883fa9e33045"
  else
    raise "Unknown operating system"
  end

  def install
    if OS.mac?
      bin.install "mac.tbl2asn" => "tbl2asn"
    elsif OS.linux?
      bin.install "linux64.tbl2asn" => "tbl2asn"
    end
  end

  test do
    system "#{bin}/tbl2asn --help"
  end
end
