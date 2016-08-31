class Hotspot < Formula
  desc "Identify regions of local enrichment of short-read sequence tags"
  homepage "https://github.com/rthurman/hotspot"
  url "https://github.com/rthurman/hotspot/archive/v4.1.0.tar.gz"
  sha256 "9ecdbba612b80f137b78314c23ac94aa6840d217bf4256faf8adee88a73fdd0c"
  revision 1

  head "https://github.com/rthurman/hotspot.git"

  bottle do
    cellar :any
    sha256 "fc949fe55227e919164e64f7e6d6f9c1c7444cca515ae4159e0deb1219864ed2" => :yosemite
    sha256 "5bd2cd5293c8e791e4e29f7bd85d9aba76a6eedbec03903f0e02722173398be2" => :mavericks
    sha256 "e69620eb7ce1bf2614a081aa206cd4802099f83a53316b29bae31e94ad5412ea" => :mountain_lion
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
