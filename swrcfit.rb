require "formula"

class Swrcfit < Formula
  desc "Fitting of soil water retention curve"
  homepage "http://swrcfit.sourceforge.net/"
  url "https://github.com/sekika/swrcfit/archive/v2.0.tar.gz"
  sha256 "7497393aa35a54c126dc1149cbf4f60e9ff798c30a2c77b887dc3524317a6127"

  head "https://github.com/sekika/swrcfit.git"

  depends_on "octave"
  depends_on "wget"

  def install
    (share / "swrcfit/example").install "swrc.txt"
    system "./Install.sh", bin
  end

  test do
    system "#{bin}/swrcfit", share / "swrcfit/example/swrc.txt"
  end
end
