class Littler < Formula
  desc "Scripting and command-line front-end for GNU R"
  homepage "http://dirk.eddelbuettel.com/code/littler.html"
  # tag "math"

  url "http://dirk.eddelbuettel.com/code/littler/littler-0.2.3.tar.gz"
  sha256 "98cd741c68a5c8f65b06c96d2f56d3b44979b3990335e7869b002c005ef80ba7"
  revision 14
  head "https://github.com/eddelbuettel/littler.git"

  bottle do
    sha256 "e03f8e6b2601bf5f783637880c22e3c218e4111aeeb5c20377288f3e391794ea" => :sierra
    sha256 "1c5ace2ab2899f1d2e0aaa86081bbf291f25fa0f9da82c6a5aa536b366d54aa4" => :el_capitan
    sha256 "fb6b0ba9342eb301ff0ae34259d936bd2f06dad73abc929e48ac8d8ec8114deb" => :yosemite
    sha256 "20aa581201bdf6a21bc974a1dc3432860011d1b4eea7c7b226bac123a283f5f7" => :x86_64_linux
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
