class Jsbsim < Formula
  desc "Open source flight dynamics model"
  homepage "http://jsbsim.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/jsbsim/JSBSim_Source/JSBSim%20v1.0%20Release%20Candidate%202/JSBSim-1.0.rc2.tar.gz"
  version "1.0.rc2"
  sha256 "04accd4efc75867edfa6eeb814ceefebf519b2e8d750518b1de0a6aafa9442e1"

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
