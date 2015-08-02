class Hotspot < Formula
  desc "Identify regions of local enrichment of short-read sequence tags"
  homepage "https://github.com/rthurman/hotspot"
  url "https://github.com/rthurman/hotspot/archive/v4.1.0.tar.gz"
  sha256 "9ecdbba612b80f137b78314c23ac94aa6840d217bf4256faf8adee88a73fdd0c"
  head "https://github.com/rthurman/hotspot.git"

  depends_on "gsl"

  def install
    ENV.deparallelize
    system "make", "-C", "hotspot-distr/hotspot-deploy"

    inreplace "hotspot-distr/pipeline-scripts/test/runall.tokens.txt",
              "/full/path/to/hotspot-distr",
              "#{pkgshare}"
    pkgshare.install "hotspot-distr/pipeline-scripts", "hotspot-distr/data"

    bin.install Dir["hotspot-distr/hotspot-deploy/bin/*"]
    doc.install %w[LICENSE README.md]
  end

  def caveats; <<-EOS.undent
    Run the test suite (~1 hr):
      #{opt_pkgshare}/pipeline-scripts/test/runhotspot
    EOS
  end
end
