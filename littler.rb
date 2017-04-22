class Littler < Formula
  desc "Scripting and command-line front-end for GNU R"
  homepage "http://dirk.eddelbuettel.com/code/littler.html"
  # tag "math"

  url "http://dirk.eddelbuettel.com/code/littler/littler-0.2.3.tar.gz"
  sha256 "98cd741c68a5c8f65b06c96d2f56d3b44979b3990335e7869b002c005ef80ba7"
  revision 10
  head "https://github.com/eddelbuettel/littler.git"

  bottle do
    sha256 "6279bb41b4f233398a464c72d0331a3c0bfd78c730c3d074cfffb9e3d6071603" => :sierra
    sha256 "62643d78cb708851f97fba73c374f8f45098bf73caadfbe2b47140d255312192" => :el_capitan
    sha256 "a70127a8f65bfad52f306270509642408f0bfe4406bcacc046c7598131cd4c22" => :yosemite
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
