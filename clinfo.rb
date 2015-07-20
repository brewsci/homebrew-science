class Clinfo < Formula
  desc "Print information about OpenCL platforms and devices"
  homepage "https://github.com/Oblomov/clinfo"
  url "https://github.com/Oblomov/clinfo/archive/2.0.15.03.24.tar.gz"
  sha256 "4b2a8a306547024de65bcf496cabe501a05539702aa790e68868039b977bbcaf"

  bottle do
    cellar :any
    sha256 "0e61fd78b8fc24277c5363054eae0dd49f5758c5ecb8361505c4ea86f5deb181" => :yosemite
    sha256 "6471d9d1c00df767e1f170745b11c6abb1ebf8ddb39946c5fd12ae145c2e587a" => :mavericks
    sha256 "83e58178fc2ac6189ababf8a65e0280e3e84536b8dda7b999e85bd84ffa9ddb3" => :mountain_lion
  end

  def install
    system "make"
    bin.install "clinfo"
    man1.install "man/clinfo.1"
  end

  test do
    output = shell_output bin/"clinfo"
    assert_match /Device Type +CPU/, output
  end
end
