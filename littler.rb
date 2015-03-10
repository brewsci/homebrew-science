class Littler < Formula
  homepage "http://dirk.eddelbuettel.com/code/littler.html"
  # tag "math"

  head "https://github.com/eddelbuettel/littler.git"
  url "http://dirk.eddelbuettel.com/code/littler/littler-0.2.2.tar.gz"
  sha1 "8008621e9448cbb29786457046a400debaed2f21"
  revision 1

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "8938abe889b5c2ea4e5a1611b11a252524d76ee0be430b6e06c9508439799310" => :yosemite
    sha256 "27c5323251f0bad99bd86b807420c6fcf1be3b1ceedb2aacc68c03f00fc88e80" => :mavericks
    sha256 "51b1066d02e258659f7a58697d3bd51ad8a1eded6cdb8ff03241075c694bd107" => :mountain_lion
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
