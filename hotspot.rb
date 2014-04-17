require "formula"

class Hotspot < Formula
  homepage "https://github.com/rthurman/hotspot"
  url "https://github.com/rthurman/hotspot/archive/v4.1.0.tar.gz"
  sha1 "d1b40651eabadd7de6110ce49ae2580cc1c1021b"
  head "https://github.com/rthurman/hotspot.git"

  depends_on "gsl"

  def install
    ENV.deparallelize
    system "make -C hotspot-distr/hotspot-deploy"

    inreplace "hotspot-distr/pipeline-scripts/test/runall.tokens.txt",
              "/full/path/to/hotspot-distr",
              "#{share}"
    share.install "hotspot-distr/pipeline-scripts", "hotspot-distr/data"

    bin.install Dir["hotspot-distr/hotspot-deploy/bin/*"]
    doc.install %w[LICENSE README.md]
  end

  def caveats; <<-EOS.undent
    Run the test suite (~1 hr):
      #{share}/pipeline-scripts/test/runhotspot
    EOS
  end
end
