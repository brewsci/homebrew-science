class Swrcfit < Formula
  desc "Fitting of soil water retention curve"
  homepage "http://swrcfit.sourceforge.net/"
  # doi "10.5194/hessd-4-407-2007"
  url "https://github.com/sekika/swrcfit/archive/v2.1.tar.gz"
  sha256 "a6038544e58db6ae7e7c310cd6537ca4509a059035667834f4b6105e0b76c1d8"

  head "https://github.com/sekika/swrcfit.git"

  depends_on "octave"
  depends_on "wget"

  def install
    (share / "swrcfit/example").install "swrc.txt"
    system "./Install.sh", bin
  end

  test do
    system "#{bin}/swrcfit", "-v"
  end
end
