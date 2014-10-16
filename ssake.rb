require "formula"

class Ssake < Formula
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/ssake"
  #doi "10.1093/bioinformatics/btl629"
  #tag "bioinformatics"
  url "http://www.bcgsc.ca/platform/bioinfo/software/ssake/releases/3.8.2/ssake_v3-8-2.tar.gz"
  version "3.8.2"
  sha1 "a06300a7715578774914c14e7e025c2d9174c39d"

  def install
    bin.install "SSAKE"
    doc.install "SSAKE.pdf", "SSAKE.readme"
    prefix.install "test", "tools"
  end

  test do
    system "SSAKE |grep SSAKE"
  end
end
