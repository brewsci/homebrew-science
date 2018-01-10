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
    sha256 "2081bf977df5f20889cb7c5ebde93a697e907b0ce4b2b45b78a2420f6ccb75c5" => :high_sierra
    sha256 "2452a512d57a512eb025d5f3165e5fb6f4dd5306c1dbbcc831c0fe10b06c17d0" => :sierra
    sha256 "19f8ac7b05c8cde4ff77abb66c1a19b76c55ce83e137b960c27e3476cc9a1010" => :el_capitan
    sha256 "1e8646d9cbd0894c5c6e620b4dfc72ada878e70b9c07f0e42e30772ad298ad28" => :x86_64_linux
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
