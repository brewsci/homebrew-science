require "formula"

class Tbl2asn < Formula
  homepage "https://www.ncbi.nlm.nih.gov/genbank/tbl2asn2/"
  version "23.9"
  if OS.mac?
    url "ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/mac.tbl2asn.gz"
    sha1 "745da05455e769d8a5b3a74385d5c91fe4135e28"
  elsif OS.linux?
    url "ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz"
    sha1 "581a07dae7a3080d2f07f33552204ed796b572c1"
  else
    raise "Unknown operating system"
  end

  resource 'doc' do
    url 'ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/DOCUMENTATION/tbl2asn.txt'
    sha1 '7b42a95b10aa6493e24074372b493dfa6fd9c9ce'
  end

  def install
    if OS.mac?
      bin.install "mac.tbl2asn" => "tbl2asn"
    elsif OS.linux?
      bin.install "linux64.tbl2asn" => "tbl2asn"
    end
    doc.install resource('doc')
  end

  test do
    system "#{bin}/tbl2asn --help"
  end
end
