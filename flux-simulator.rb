class FluxSimulator < Formula
  homepage "http://sammeth.net/confluence/display/SIM/Home"
  url "http://artifactory.sammeth.net/artifactory/barna/barna/barna.simulator/1.2.1/flux-simulator-1.2.1.tgz"
  sha256 "9e4da0b4e1c21bddd9f8d0cca67bd6a55de43c08db40833ac2fbb531f3a8cff1"

  bottle do
    cellar :any
    sha256 "68231532c19d443f371ca74e80072e89558727eeecd0288eefd163658feb6368" => :yosemite
    sha256 "59be70eccfeff668f29d8478aba0e1a72d06d76a76b72d298e5aa8860d83c407" => :mavericks
    sha256 "a68826b481a25676e5f2e0a3525b483ad76bf11a614ad1874f64658d12fd5afe" => :mountain_lion
  end

  def install
    inreplace "bin/flux-simulator", 'libdir="$dir/../lib"', 'libdir="$dir/../libexec"'
    libexec.install Dir["lib/*.jar"]
    bin.install "bin/flux-simulator"
  end

  test do
    system "flux-simulator", "-o"
  end
end
