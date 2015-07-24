class Yaggo < Formula
  desc "Generate command-line parsers for C++"
  homepage "https://github.com/gmarcais/yaggo"
  url "https://github.com/gmarcais/yaggo/archive/v1.5.5.tar.gz"
  sha256 "8aae8024c3d832bf6a93513276a85413a129513d00c4f10c317124414d6a3f50"
  head "https://github.com/gmarcais/yaggo.git"

  bottle do
    cellar :any
    sha256 "2b02a318dfc967e09ffca0e08e863a773a4a69bcdcc3330e9855305879e28e5f" => :yosemite
    sha256 "1bed00bb4046bf1d45d9ce347a4ef3c1cebdff23f1bc8b3e4801577ad8908926" => :mavericks
    sha256 "72d376f21e01993bd3ee9e9d3c5d9ab8752868a4db5bdac521cf28a75fd97ac2" => :mountain_lion
  end

  def install
    bin.mkpath
    system "make", "DEST=#{bin}"
    doc.install "README.md"
  end

  test do
    system "#{bin}/yaggo", "--version"
  end
end
