class Swrcfit < Formula
  desc "Fitting of soil water retention curve"
  homepage "http://swrcfit.sourceforge.net/"
  # doi "10.5194/hessd-4-407-2007"
  url "https://github.com/sekika/swrcfit/archive/v2.1.tar.gz"
  sha256 "a6038544e58db6ae7e7c310cd6537ca4509a059035667834f4b6105e0b76c1d8"

  head "https://github.com/sekika/swrcfit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf912ac45ab874a4a3a9127ec019d952429acb84764aee9395fd7447b2ac8e76" => :el_capitan
    sha256 "24b0d41cf132bd5d095aa3f7db1eb1fcd9f248bb7d016dade491eb81d1c7e6a3" => :yosemite
    sha256 "8e57d8f35d20d8cc12e4218b1dce690230ccf45d1db0477ef6639eeae0856894" => :mavericks
  end

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
