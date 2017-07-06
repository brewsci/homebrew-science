class Littler < Formula
  desc "Scripting and command-line front-end for GNU R"
  homepage "http://dirk.eddelbuettel.com/code/littler.html"
  # tag "math"

  url "http://dirk.eddelbuettel.com/code/littler/littler-0.2.3.tar.gz"
  sha256 "98cd741c68a5c8f65b06c96d2f56d3b44979b3990335e7869b002c005ef80ba7"
  revision 12
  head "https://github.com/eddelbuettel/littler.git"

  bottle do
    sha256 "2abfff2b9297200ffc0be8bc135464baad2adc10b3cdd1c65c3f1063dd516e53" => :sierra
    sha256 "e093d8a045ab3073b3202ab64b8a0ad64106c563e3b747831a4a237f5aa0a889" => :el_capitan
    sha256 "243617b1e1fe47260c70d8957985ed6656c853a7a39d969a4b99f65a71eb66a3" => :yosemite
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
