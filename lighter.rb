class Lighter < Formula
  homepage "https://github.com/mourisl/Lighter"
  # tag 'bioinformatics'
  # doi '10.1186/s13059-014-0509-9'
  url "https://github.com/mourisl/Lighter/archive/v1.0.5.tar.gz"
  sha1 "a39e399cedf48ee01d4244b4184355d19dfc438b"
  head "https://github.com/mourisl/Lighter.git"

  bottle do
    cellar :any
    sha1 "d643e55d2b6b165eb85da63363a199920e32cace" => :yosemite
    sha1 "5a54e5e535c1e3f5662c6b009c33c56eb77c3145" => :mavericks
    sha1 "aa88bf40adcb470a41729e0a30c0c1ba91c62e55" => :mountain_lion
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
