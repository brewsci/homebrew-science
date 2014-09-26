require "formula"

class Ssake < Formula
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/ssake"
  #doi "10.1093/bioinformatics/btl629"
  #tag "bioinformatics"
  url "http://www.bcgsc.ca/platform/bioinfo/software/ssake/releases/3.8.2/ssake_v3-8-2.tar.gz"
  version "3.8.2"
  sha1 "aa8c6411e2df3256d5bf84bede6200f24b6d7f77"

  def install
    bin.install "SSAKE"
    doc.install "SSAKE.pdf", "SSAKE.readme"
    prefix.install "test", "tools"
  end

  test do
    system "SSAKE |grep SSAKE"
  end
end
