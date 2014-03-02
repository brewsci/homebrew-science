require 'formula'

class Rainbow < Formula
  homepage 'http://sourceforge.net/projects/bio-rainbow/'
  url 'https://downloads.sourceforge.net/project/bio-rainbow/rainbow_2.0.2.tar.gz'
  sha1 'e3b91dd0900d9ec3e033a844eee1d156a4b33b71'

  def install
    system 'make'
    bin.install %w{rainbow ezmsim rbasm rbmergetag}
  end

  test do
    system 'rainbow 2>&1 |grep -q rainbow'
  end
end
