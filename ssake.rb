class Ssake < Formula
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/ssake"
  #doi "10.1093/bioinformatics/btl629"
  #tag "bioinformatics"

  url "http://www.bcgsc.ca/platform/bioinfo/software/ssake/releases/3.8.2/ssake_v3-8-2.tar.gz"
  version "3.8.2"
  sha1 "a06300a7715578774914c14e7e025c2d9174c39d"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "5cb173578454d2734be7728649731052736f5314" => :yosemite
    sha1 "8f120502cadff08b74dff6efe540c3a6f455d26b" => :mavericks
    sha1 "d8ea940b5e2aacb30509e698f3530688923678fe" => :mountain_lion
  end

  def install
    bin.install "SSAKE"
    doc.install "SSAKE.pdf", "SSAKE.readme"
    prefix.install "test", "tools"
  end

  test do
    system "SSAKE |grep SSAKE"
  end
end
