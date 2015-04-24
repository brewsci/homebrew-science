class FluxSimulator < Formula
  homepage "http://sammeth.net/confluence/display/SIM/Home"
  version "1.2.1"
  url "http://artifactory.sammeth.net/artifactory/barna/barna/barna.simulator/#{version}/flux-simulator-#{version}.tgz"
  sha256 "9e4da0b4e1c21bddd9f8d0cca67bd6a55de43c08db40833ac2fbb531f3a8cff1"

  def install
    inreplace "bin/flux-simulator", 'libdir="$dir/../lib"', 'libdir="$dir/../libexec"'
    libexec.install Dir["lib/*.jar"]
    bin.install "bin/flux-simulator"
  end

  test do
    system "flux-simulator", "-o"
  end
end
