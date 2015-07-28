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
    sha256 "7f60cbb79ea3dda1c729aaf93545a84b0baa1c3ff24c8c7eac0f034939cde3d9" => :yosemite
    sha256 "e1c981cff85350143704b3fd14f511d6f7ff78c81c8108932f1cc29b299ac16f" => :mavericks
    sha256 "a4007f03c452268fe047d35425133fe845ece973192b4e277e2c1265686c3dac" => :mountain_lion
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
