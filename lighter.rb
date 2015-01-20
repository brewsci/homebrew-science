class Lighter < Formula
  homepage "https://github.com/mourisl/Lighter"
  # tag 'bioinformatics'
  # doi '10.1186/s13059-014-0509-9'
  url "https://github.com/mourisl/Lighter/archive/v1.0.5.tar.gz"
  sha1 "a39e399cedf48ee01d4244b4184355d19dfc438b"
  head "https://github.com/mourisl/Lighter.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "1f2dd126ec78d95a531e716a1f265e0fb930d8b5" => :yosemite
    sha1 "fde8a4d850ffc61638541a4d3e23990e28dc3f92" => :mavericks
    sha1 "40c17c280f3629d6b447d33bd42a0dd0e6a6d984" => :mountain_lion
  end

  def install
    system "make"
    bin.install "lighter"
    doc.install "README.md", "LICENSE"
  end

  test do
    system "#{bin}/lighter", "-h"
  end
end
