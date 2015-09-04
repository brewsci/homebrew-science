class Yaggo < Formula
  desc "Generate command-line parsers for C++"
  homepage "https://github.com/gmarcais/yaggo"
  url "https://github.com/gmarcais/yaggo/archive/v1.5.6.tar.gz"
  sha256 "05511a3e2691fdd1a45f50d57a3e194c7d941eba0262d16e827543d696f2eb60"
  head "https://github.com/gmarcais/yaggo.git"

  bottle do
    cellar :any
    sha256 "2b02a318dfc967e09ffca0e08e863a773a4a69bcdcc3330e9855305879e28e5f" => :yosemite
    sha256 "1bed00bb4046bf1d45d9ce347a4ef3c1cebdff23f1bc8b3e4801577ad8908926" => :mavericks
    sha256 "72d376f21e01993bd3ee9e9d3c5d9ab8752868a4db5bdac521cf28a75fd97ac2" => :mountain_lion
  end

  depends_on :ruby => ["1.9", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/yaggo", "--version"
  end
end
