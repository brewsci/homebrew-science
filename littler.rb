class Littler < Formula
  homepage "http://dirk.eddelbuettel.com/code/littler.html"
  # tag "math"

  url "http://dirk.eddelbuettel.com/code/littler/littler-0.2.2.tar.gz"
  sha1 "8008621e9448cbb29786457046a400debaed2f21"
  head "https://github.com/eddelbuettel/littler.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "4cff32fcb9258d63dca1360b279a53f01ec62130" => :yosemite
    sha1 "ea63ab0bc7ab6ca73cb8cce0413424a85c56f2cd" => :mavericks
    sha1 "0338725582ab8c72a8b812705ede42e65d81af5b" => :mountain_lion
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
