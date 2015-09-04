class Yaggo < Formula
  desc "Generate command-line parsers for C++"
  homepage "https://github.com/gmarcais/yaggo"
  url "https://github.com/gmarcais/yaggo/archive/v1.5.6.tar.gz"
  sha256 "05511a3e2691fdd1a45f50d57a3e194c7d941eba0262d16e827543d696f2eb60"
  head "https://github.com/gmarcais/yaggo.git"

  bottle do
    cellar :any
    sha256 "adbfa2e8043fd886be69ba88487a1c4fbfd54787f53e9d984513612579490b53" => :yosemite
    sha256 "51bd80fadc1dc00d86a8072a0dd13e3010d6b27981eeb28c68879ce1f844baee" => :mavericks
    sha256 "aa0783ba2a6c62f6fdb4d483d957e29419a3d8899eace162270455d3e1ad505b" => :mountain_lion
  end

  depends_on :ruby => ["1.9", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/yaggo", "--version"
  end
end
