class Tbl2asn < Formula
  desc "Automates the submission of sequence records to GenBank"
  homepage "https://www.ncbi.nlm.nih.gov/genbank/tbl2asn2/"
  # tag "bioinformatics"

  # version number is in https://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/DOCUMENTATION/VERSIONS
  version "25.6"
  if OS.mac?
    url "https://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/mac.tbl2asn.gz"
    sha256 "c79416ff5fea23baf4ac10ff1a67f7f6e099980a45ac878f649821ba7b68788b"
  elsif OS.linux?
    url "https://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz"
    sha256 "5306321c1e9cd709c41a47a01c8193cff20bc2c71141037e739dd8b59cb30dc2"
  end

  unless OS.mac?
    depends_on "patchelf" => :build
    depends_on "libidn"
    depends_on "zlib"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d1d425c14dac16911a3cd2f55968da21bea1519c305ebec58c2154ef330b4b4a" => :sierra
    sha256 "5e9baf2faa15d2a9e9eada81d4edcf09ea09e5e40952b44ed341e8e902980c8d" => :el_capitan
    sha256 "1afa149ee069a6e78b3f4c7305e1f361d44d2a97d93e7cd175e5744d44bbd70c" => :yosemite
    sha256 "2b8f4195c4a7facfe48fc86e4c58cad36431bdcd685568790dc2baaceb35c9e1" => :x86_64_linux
  end

  resource "doc" do
    url "https://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/DOCUMENTATION/tbl2asn.txt"
    sha256 "b5e139c2a22cea4e1b5c7a063e3fb1f311d6b8802f2a8cca1433d7f16f816300"
  end

  def install
    if OS.mac?
      bin.install "mac.tbl2asn" => "tbl2asn"
    elsif OS.linux?
      bin.install "linux64.tbl2asn" => "tbl2asn"
      system "patchelf",
        "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
        "--set-rpath", HOMEBREW_PREFIX/"lib",
        bin/"tbl2asn"
    end
    doc.install resource("doc")
  end

  test do
    assert_match "tbl2asn #{version}", shell_output("#{bin}/tbl2asn -")
  end
end
