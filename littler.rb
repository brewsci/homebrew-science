class Littler < Formula
  desc "Scripting and command-line front-end for GNU R"
  homepage "http://dirk.eddelbuettel.com/code/littler.html"
  # tag "math"

  url "http://dirk.eddelbuettel.com/code/littler/littler-0.2.3.tar.gz"
  sha256 "98cd741c68a5c8f65b06c96d2f56d3b44979b3990335e7869b002c005ef80ba7"
  revision 7
  head "https://github.com/eddelbuettel/littler.git"

  bottle do
    sha256 "b79b50c19a65fb4ebbb137efc93c5fbc0ba7e3223ac9bf49352ba0deb06e1496" => :sierra
    sha256 "2a449309dfebbccfac9c4202cd6bb81dcc92019da342d76149346387861d83c1" => :el_capitan
    sha256 "afcf0b97b58533e22733488497717250de053c76839b2c2d6693d4a3692bf3df" => :yosemite
    sha256 "65b92ef849f0f0a482bad239994e0345d9c72727ee5cf3caabd07bf1514b420a" => :x86_64_linux
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
