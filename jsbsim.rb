class Jsbsim < Formula
  desc "Open source flight dynamics model"
  homepage "http://jsbsim.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/jsbsim/JSBSim_Source/JSBSim%20v1.0%20Release%20Candidate%202/JSBSim-1.0.rc2.tar.gz"
  version "1.0.rc2"
  sha256 "04accd4efc75867edfa6eeb814ceefebf519b2e8d750518b1de0a6aafa9442e1"

  bottle do
    cellar :any_skip_relocation
    sha256 "a88430d291a5ffb8cff4dd62c122acc976cf10e0a7a362e06b1713447ecb742a" => :el_capitan
    sha256 "a98477ca4a33b32e4bcabce5a0c8a941992afbde2c5056a7a15fc385fdf811a9" => :yosemite
    sha256 "992d34b5e4c61efdaeda03c3a493db32094e63c38909fb4cdf082fdcd0dfc8c0" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-libraries"

    system "make", "install"

    bin.install "src/JSBSim"
  end

  test do
    system "#{bin}/JSBSim"
  end
end
