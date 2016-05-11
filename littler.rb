class Littler < Formula
  homepage "http://dirk.eddelbuettel.com/code/littler.html"
  # tag "math"

  head "https://github.com/eddelbuettel/littler.git"
  url "http://dirk.eddelbuettel.com/code/littler/littler-0.2.3.tar.gz"
  sha256 "98cd741c68a5c8f65b06c96d2f56d3b44979b3990335e7869b002c005ef80ba7"
  revision 6

  bottle do
    sha256 "df1a3168bdc396b4836021ba476be411accc38e7cb325e0c67ffe7591dadf253" => :el_capitan
    sha256 "839db50bf0480969a14ab9a1f76b4205dcfc0c5f49c6a9dc462df29f769a438b" => :yosemite
    sha256 "a66097e9641d1c7671cb8d3ab87cbf5a74d7f18d1b4637d34a6bc5e9c82670b5" => :mavericks
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
