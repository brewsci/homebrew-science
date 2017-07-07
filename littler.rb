class Littler < Formula
  desc "Scripting and command-line front-end for GNU R"
  homepage "http://dirk.eddelbuettel.com/code/littler.html"
  # tag "math"

  url "http://dirk.eddelbuettel.com/code/littler/littler-0.2.3.tar.gz"
  sha256 "98cd741c68a5c8f65b06c96d2f56d3b44979b3990335e7869b002c005ef80ba7"
  revision 13
  head "https://github.com/eddelbuettel/littler.git"

  bottle do
    sha256 "c186e37116bf93f688cfc03d4c851a079ae0bd2cbe232e9a7f007dc7aa6ef417" => :sierra
    sha256 "d5788877af5894e01ea6fd5fea0dc1f3835d1cff0ea59b26bfeb12f8a0300d74" => :el_capitan
    sha256 "34f05dbb6789126afa1a0ab0d36bcc0db884b161ff6b8794236b158cd2373ef5" => :yosemite
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
