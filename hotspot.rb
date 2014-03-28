require "formula"

class Hotspot < Formula
  homepage "https://github.com/rthurman/hotspot"
  url "https://github.com/rthurman/hotspot/archive/4.0.0.tar.gz"
  sha1 "5686637ac1653ba7d8a408f5f49b8d50cff61467"
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
