class Hotspot < Formula
  desc "Identify regions of local enrichment of short-read sequence tags"
  homepage "https://github.com/rthurman/hotspot"
  url "https://github.com/rthurman/hotspot/archive/v4.1.0.tar.gz"
  sha256 "9ecdbba612b80f137b78314c23ac94aa6840d217bf4256faf8adee88a73fdd0c"
  revision 1

  head "https://github.com/rthurman/hotspot.git"

  bottle do
    cellar :any
    sha256 "3aa6e14332036fa6fca63ea2d5c6ba77cbf74aee8ed4bafd70d35fc47fb485ea" => :sierra
    sha256 "8b37a09702e2b76c5cba0165f6699f56b5ba109d4ef083d193f2c43e437ddb59" => :el_capitan
    sha256 "eb2ae1d0b6a85d8273da8bcc1b4b563f5fde3ca8d0b61e3875f2dacde51cd9e8" => :yosemite
  end

  depends_on "gsl"

  def install
    ENV.deparallelize
    system "make", "-C", "hotspot-distr/hotspot-deploy"

    inreplace "hotspot-distr/pipeline-scripts/test/runall.tokens.txt",
              "/full/path/to/hotspot-distr", pkgshare
    pkgshare.install "hotspot-distr/pipeline-scripts", "hotspot-distr/data"

    bin.install Dir["hotspot-distr/hotspot-deploy/bin/*"]
    rm bin/"wavelets" unless OS.linux?
  end

  def caveats; <<-EOS.undent
    Run the test suite (~1 hr):
      #{opt_pkgshare}/pipeline-scripts/test/runhotspot
    EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/hotspot 2>&1", 1)
  end
end
