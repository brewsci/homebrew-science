require "formula"

class Swrcfit < Formula
  homepage "http://swrcfit.sourceforge.net/"
  url "https://github.com/sekika/swrcfit/archive/v1.3.tar.gz"
  sha1 "48c6fdcd76adfe49177ebabdf0bd95e88c31286b"

  head "https://github.com/sekika/swrcfit.git"

  depends_on "octave"
  depends_on "wget"

  def install
    (share / "swrcfit/example").install "swrc.txt"
    system "mkdir", bin
    system "./Install.sh", bin
  end

  test do
    system "#{bin}/swrcfit", share / "swrcfit/example/swrc.txt"
  end
end
