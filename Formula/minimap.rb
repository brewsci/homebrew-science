class Minimap < Formula
  desc "Find approx mapping positions between long sequences"
  homepage "https://github.com/lh3/minimap"
  # tag "bioinformatics"

  url "https://github.com/lh3/minimap/archive/v0.2.tar.gz"
  sha256 "cfcf77cfe2d8d64b16ea60e0139363190eca4853da9dca9d872c38fe80bf5d68"

  head "https://github.com/lh3/minimap.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d75b6b13442bc2e542d2352296ad0b00c9bc5d9da1bf93618a0a4efe160d8f31" => :el_capitan
    sha256 "8981895e47efa6ed19887372183a978990970c75dd118e520a74aff388df11f9" => :yosemite
    sha256 "37408691b9cf1146ca1873af6b42efbd103b34f910933ae31038ca31d9cac3bc" => :mavericks
    sha256 "9dd196a49ded3bdc92d7bdc20a1a71ca662b005b65121724727f1b4b988385e1" => :x86_64_linux
  end

  def install
    system "make"
    bin.install "minimap"
  end

  test do
    assert_match "mapping", shell_output("#{bin}/minimap 2>&1", 1)
  end
end
