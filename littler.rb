class Littler < Formula
  homepage "http://dirk.eddelbuettel.com/code/littler.html"
  # tag "math"

  head "https://github.com/eddelbuettel/littler.git"
  url "http://dirk.eddelbuettel.com/code/littler/littler-0.2.3.tar.gz"
  sha256 "98cd741c68a5c8f65b06c96d2f56d3b44979b3990335e7869b002c005ef80ba7"
  revision 3

  bottle do
    sha256 "69f96066fee705ad427275c85a58d3f4b276e42ef3b61ac3ae37278845a6ee3a" => :el_capitan
    sha256 "a90f023824afef1ea158e66bb8dffa71d3e117fbf0a7792286e9517da3e0f042" => :yosemite
    sha256 "0c488078624189b3f013b7d4ac30b0d2ba6f697b2c283ba28c5ed4c632d78d26" => :mavericks
  end

  depends_on "r"

  def install
    ENV.deparallelize
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make"

    bin.install "r" => "littler"
    man1.install "r.1" => "littler.1"
    doc.install "README"
  end

  def caveats; <<-EOS.undent
    This formula installs `r` as `littler` to avoid conflicting
    with the Zsh builtin and case-insensitive filesystems.
    EOS
  end

  test do
    system "#{bin}/littler", "-e", "'print(pi)'"
  end
end
