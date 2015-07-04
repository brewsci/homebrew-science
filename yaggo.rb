class Yaggo < Formula
  desc "Generate command-line parsers for C++"
  homepage "https://github.com/gmarcais/yaggo"
  url "https://github.com/gmarcais/yaggo/archive/v1.5.5.tar.gz"
  sha256 "8aae8024c3d832bf6a93513276a85413a129513d00c4f10c317124414d6a3f50"
  head "https://github.com/gmarcais/yaggo.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "ede41d5f56f1891e7f8cded47408a336cda5a06a" => :yosemite
    sha1 "1f29452de12580785532298d047cdce559369784" => :mavericks
    sha1 "a8d79edd5fecd2fb69c6b79c8fd3725c23bc3202" => :mountain_lion
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
