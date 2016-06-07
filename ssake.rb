class Ssake < Formula
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/ssake"
  # doi "10.1093/bioinformatics/btl629"
  # tag "bioinformatics"

  url "http://www.bcgsc.ca/platform/bioinfo/software/ssake/releases/3.8.4/ssake_v3-8-4.tar.gz"
  version "3.8.4"
  sha256 "55fad26faa2b33841c58c7e52ed85c98bac2f65ffd48a40d09ba5e274ccb5d87"

  bottle do
    cellar :any_skip_relocation
    sha256 "c51b0294aace8714001b1d3d08af9239262b751636bf1eb61a8c6dfb65e6bd92" => :el_capitan
    sha256 "8332def65e6f706db2371ef9fd7025ebb48ffcb2f3d5520ca4a8c784f8098f34" => :yosemite
    sha256 "f6744c3239aea0f6b4ef1cd3ded7d1669b387281b9343752a5684533a6cc4da4" => :mavericks
    sha256 "9abcae280ed5a6bb4d72202e70217444a91ce7056817d8477915a2aaf5b651ce" => :x86_64_linux
  end

  def install
    bin.install "SSAKE"
    doc.install "SSAKE-readme.pdf", "SSAKE-readme.txt"
    prefix.install "test", "tools"
  end

  test do
    system "SSAKE |grep SSAKE"
  end
end
