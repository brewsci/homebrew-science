class Rainbow < Formula
  desc "Short reads clustering and local assembly"
  homepage "https://sourceforge.net/projects/bio-rainbow/"
  url "https://downloads.sourceforge.net/project/bio-rainbow/rainbow_2.0.4.tar.gz"
  sha256 "79281aae3bccd1ad467afef6fc7c8327aaa8d56f538821e2833d2b8f26b5bafc"

  def install
    system "make"
    bin.install %w[rainbow ezmsim rbasm]
  end

  test do
    system "#{bin}/rainbow 2>&1 |grep -q rainbow"
  end
end
