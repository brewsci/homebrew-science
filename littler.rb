class Littler < Formula
  desc "Scripting and command-line front-end for GNU R"
  homepage "http://dirk.eddelbuettel.com/code/littler.html"
  # tag "math"

  url "http://dirk.eddelbuettel.com/code/littler/littler-0.2.3.tar.gz"
  sha256 "98cd741c68a5c8f65b06c96d2f56d3b44979b3990335e7869b002c005ef80ba7"
  revision 8
  head "https://github.com/eddelbuettel/littler.git"

  bottle do
    sha256 "17d127916bb7cf5848e89649ed672f9c09068375949d45633a3057cc1b945231" => :sierra
    sha256 "9dfb102047e3af2a66fa7d5b7bf21a73de0e4ece52d11e50db3b002c863710a9" => :el_capitan
    sha256 "836eccea9a5ead94338acf0feefc8b7944aae635e50c6472869c969ab84ca9d3" => :yosemite
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
