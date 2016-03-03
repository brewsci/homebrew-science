class Littler < Formula
  homepage "http://dirk.eddelbuettel.com/code/littler.html"
  # tag "math"

  head "https://github.com/eddelbuettel/littler.git"
  url "http://dirk.eddelbuettel.com/code/littler/littler-0.2.3.tar.gz"
  sha256 "98cd741c68a5c8f65b06c96d2f56d3b44979b3990335e7869b002c005ef80ba7"
  revision 3

  bottle do
    sha256 "6d6cde64cfab4577caee9af690c6203fc43d385e123bbf0669b747810756dd7b" => :el_capitan
    sha256 "dc073de6db3f2e26da79cdbf6cdca4d113d63211ad5a71f6cdc4d728fc61a8ef" => :yosemite
    sha256 "f25556651c1e40dbbe7ac9a6bc0e305c5bcd7550511f54fd68f58c4181259b93" => :mavericks
  end

  depends_on "r"

  def install
    ENV.deparallelize
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
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
