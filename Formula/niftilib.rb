class Niftilib < Formula
  homepage "https://niftilib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/niftilib/nifticlib/nifticlib_2_0_0/nifticlib-2.0.0.tar.gz"
  sha256 "a3e988e6a32ec57833056f6b09f940c69e79829028da121ff2c5c6f7f94a7f88"

  def install
    ENV.deparallelize
    system "make"
    bin.install Dir["bin/*"]
    lib.install Dir["lib/*"]
    include.install Dir["include/*"]
  end
end
