class Minimap < Formula
  desc "Find approx mapping positions between long sequences"
  homepage "https://github.com/lh3/minimap"
  # tag "bioinformatics"

  url "https://github.com/lh3/minimap/archive/v0.2.tar.gz"
  sha256 "cfcf77cfe2d8d64b16ea60e0139363190eca4853da9dca9d872c38fe80bf5d68"

  head "https://github.com/lh3/minimap.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3905460562a5bd6a56e1c17f2fb8985ea51c1b3f51d7bb87d2edff65bd2570a9" => :el_capitan
    sha256 "f79e81d855a599d1539904a12fdba4d2ad5123b9f034109ea4f04b19619070fc" => :yosemite
    sha256 "81d18e1798db3e75ae756f87cccbd0cf4109ee461ae25e0129668f1dd10ff435" => :mavericks
  end

  def install
    system "make"
    bin.install "minimap"
  end

  test do
    assert_match "mapping", shell_output("#{bin}/minimap 2>&1", 1)
  end
end
