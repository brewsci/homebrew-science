class Yaggo < Formula
  desc "Generate command-line parsers for C++"
  homepage "https://github.com/gmarcais/yaggo"
  url "https://github.com/gmarcais/yaggo/archive/v1.5.10.tar.gz"
  sha256 "3a81532d3be8109a0e44949a04ccf74cc1b5c8fee47789a12c8cabc6fa0b1e4f"
  head "https://github.com/gmarcais/yaggo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eac780150769d36fca3a2719dacea9af18c96dfa05d642290da1a44557bd4dd4" => :sierra
    sha256 "bd5bc4bcdb8e818370832055bd77161c8137bf6ba83b1ccdce24c462e5de506a" => :el_capitan
    sha256 "bd5bc4bcdb8e818370832055bd77161c8137bf6ba83b1ccdce24c462e5de506a" => :yosemite
    sha256 "ce0926f6dd71a74778423581bb7201e4439d687d6264fbfbbacc89caee6d8f9c" => :x86_64_linux
  end

  depends_on :ruby => ["1.9", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/yaggo", "--version"
  end
end
