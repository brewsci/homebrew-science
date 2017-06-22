class Wiggletools < Formula
  desc "Compute genome-wide statistics with composable iterators"
  homepage "https://github.com/Ensembl/WiggleTools"
  url "https://github.com/Ensembl/WiggleTools/archive/v1.2.2.tar.gz"
  sha256 "e9e75b09bcc8aeb012c49937c543e2b05379d3983ba8f6798ca8d6a4171702d9"
  revision 1
  head "https://github.com/Ensembl/WiggleTools.git"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btt737"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3e8608fe94cbf06138392adf41978b6e8aff664f48a1afa4ccda46e2e258a155" => :sierra
    sha256 "f592e4c356f20ada43a98eb19e28c4c0e54be564a52f428d363e0a719cefd1c6" => :el_capitan
    sha256 "6db2a470664e190084ccf40b46150a8fb8d5ef2affbb796e1b9a9628262ba201" => :yosemite
    sha256 "56bda789ab498686bcb2c68f6eab60e6331e76ad229b45ddfdb3cf0874c3d281" => :x86_64_linux
  end

  depends_on "curl" unless OS.mac?
  depends_on "gsl"
  depends_on "htslib"
  depends_on "libbigwig"

  def install
    system "make"
    pkgshare.install "test"
    lib.install "lib/libwiggletools.a"
    bin.install "bin/wiggletools"
  end

  test do
    cp_r pkgshare/"test", testpath
    cp_r prefix/"bin", testpath
    cd "test" do
      system "python2.7", "test.py"
    end
  end
end
