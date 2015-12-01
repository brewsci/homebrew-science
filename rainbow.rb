class Rainbow < Formula
  homepage "http://sourceforge.net/projects/bio-rainbow/"
  url "https://downloads.sourceforge.net/project/bio-rainbow/rainbow_2.0.2.tar.gz"
  sha256 "e33b126f88e374ae2d26a83a0a5e3223fb4b2ea9fd494c788e95bfa4684105f4"

  def install
    system "make"
    bin.install %w[rainbow ezmsim rbasm rbmergetag]
  end

  test do
    system "rainbow 2>&1 |grep -q rainbow"
  end
end
