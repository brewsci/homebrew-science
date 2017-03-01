class Swrcfit < Formula
  desc "Fitting of soil water retention curve"
  homepage "https://swrcfit.sourceforge.io/"
  # doi "10.5194/hessd-4-407-2007"
  url "https://github.com/sekika/swrcfit/archive/v3.0.tar.gz"
  sha256 "bee47347bad5db0ac72597b82d5fff20278e57d5792e431f6d987c52360d7021"
  revision 1
  head "https://github.com/sekika/swrcfit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3fb985388df4be9c1b59b9d12490163c5a0c41c07c1562a235442226f28d1a57" => :sierra
    sha256 "17e55b8bc2e6e12225cb30ca0743f4f1e90f5c9bf5fb15209411e9685392dcb6" => :el_capitan
    sha256 "7d2f1cf07961151d9ceeec57194efd3a5a3fb5e6226b14187e1936f8def33869" => :yosemite
  end

  depends_on "octave"
  depends_on "wget"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/swrcfit", "-v"
  end
end
