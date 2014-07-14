require "formula"

class Tbl2asn < Formula
  homepage "https://www.ncbi.nlm.nih.gov/genbank/tbl2asn2/"
  version "23.6"
  if OS.mac?
    url "ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/mac.tbl2asn.gz"
    sha1 "80b9bb33ffb9b070ef40107b399d380485044366"
  elsif OS.linux?
    url "ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz"
    sha1 "436e5143547b918514cc90c77b9b7b483eadf035"
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
