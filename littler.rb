class Littler < Formula
  desc "Scripting and command-line front-end for GNU R"
  homepage "http://dirk.eddelbuettel.com/code/littler.html"
  # tag "math"

  url "http://dirk.eddelbuettel.com/code/littler/littler-0.2.3.tar.gz"
  sha256 "98cd741c68a5c8f65b06c96d2f56d3b44979b3990335e7869b002c005ef80ba7"
  revision 10
  head "https://github.com/eddelbuettel/littler.git"

  bottle do
    sha256 "e7c7e8e7e41efa5e76943dd2b6a0e987528a2f5a4eb110a86ed0af9f814cad86" => :sierra
    sha256 "898fbc9b102ca539e2a4483966af8d0d57fc3c0a068808dbf4655a298d413bc2" => :el_capitan
    sha256 "14aeeb75423852a5b92936ce80419ed290c5f73eb01baec8c594024965de3f94" => :yosemite
    sha256 "d51074995311592647f66f0838171bc718651e505fa803e9f3c282fceacf5c26" => :x86_64_linux
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
