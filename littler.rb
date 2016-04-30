class Littler < Formula
  homepage "http://dirk.eddelbuettel.com/code/littler.html"
  # tag "math"

  head "https://github.com/eddelbuettel/littler.git"
  url "http://dirk.eddelbuettel.com/code/littler/littler-0.2.3.tar.gz"
  sha256 "98cd741c68a5c8f65b06c96d2f56d3b44979b3990335e7869b002c005ef80ba7"
  revision 5

  bottle do
    sha256 "a6a55c810b672d581f348da88a68e956edaacaa12e6f4a7bc4e9c1e21f9f4a10" => :el_capitan
    sha256 "4a71092f7ead9561671c2a9983169f39abdc1437bb66867a37c20b85665c3e92" => :yosemite
    sha256 "14a27222a60d8c92ffc13f322364246267d901eeb9aaede265e7e324ea1c35f1" => :mavericks
  end

  depends_on "r"

  def install
    ENV.deparallelize
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    inreplace "Makefile", Formula["r"].prefix, Formula["r"].opt_prefix
    system "make", "littler.h"
    inreplace "littler.h", Formula["r"].prefix, Formula["r"].opt_prefix
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
