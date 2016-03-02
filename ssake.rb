class Ssake < Formula
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/ssake"
  # doi "10.1093/bioinformatics/btl629"
  # tag "bioinformatics"

  url "http://www.bcgsc.ca/platform/bioinfo/software/ssake/releases/3.8.4/ssake_v3-8-4.tar.gz"
  version "3.8.4"
  sha256 "55fad26faa2b33841c58c7e52ed85c98bac2f65ffd48a40d09ba5e274ccb5d87"

  bottle do
    cellar :any
    ###These need to be updated
    sha256 "855dbecf9e0d6e3446f13554554dd00e45a97d17169396a19ab944a6a290f871" => :yosemite
    sha256 "777fe71291d557f325b3c52263a2da67d0ff10e6409f3d98b2ee252b05237bc7" => :mavericks
    sha256 "7c24da4cb25ced6056f8932266a159b2223f5b2425e0adedef54128dac36fb8a" => :mountain_lion
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
