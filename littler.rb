class Littler < Formula
  desc "Scripting and command-line front-end for GNU R"
  homepage "http://dirk.eddelbuettel.com/code/littler.html"
  # tag "math"

  url "http://dirk.eddelbuettel.com/code/littler/littler-0.2.3.tar.gz"
  sha256 "98cd741c68a5c8f65b06c96d2f56d3b44979b3990335e7869b002c005ef80ba7"
  revision 11
  head "https://github.com/eddelbuettel/littler.git"

  bottle do
    sha256 "181922656bbdbd36e693b5fc8067218baa37f3ede7c990b1a4d6214601a56c84" => :sierra
    sha256 "83d815533bc3145a94c7ac128c069e8fe45528a74b26b026f1b6d4e411131cd6" => :el_capitan
    sha256 "c97318cdffe067cfe4a0a2dadf708536a6f2fd95e8bd689843f2b883c3dc7e28" => :yosemite
    sha256 "f4ddf308be8ada97385dd77fab22daf130af941b1c071d3e27652fd417822873" => :x86_64_linux
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
