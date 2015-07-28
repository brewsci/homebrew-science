class Lighter < Formula
  desc "Fast and memory-efficient sequencing error corrector"
  homepage "https://github.com/mourisl/Lighter"
  # tag 'bioinformatics'
  # doi '10.1186/s13059-014-0509-9'

  url "https://github.com/mourisl/Lighter/archive/v1.0.7.tar.gz"
  sha256 "fde9969f49fa618d12713473b15c79884f91da6017710329e3c9f890f464465f"
  head "https://github.com/mourisl/Lighter.git"

  bottle do
    cellar :any
    sha256 "0cfd10552918cbea28e5e3bf2a8c9d87b220da3eda6c0c7cbcf9764f7494b49c" => :yosemite
    sha256 "65dc90163a1ad643d49d88f2769cfa65c176b19d5485081819cb2b8c52130996" => :mavericks
    sha256 "72a4d55edc5b4504d6c72201b5fcf5388c49f2ff3d97ae9c2d9f5e301af252f5" => :mountain_lion
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
