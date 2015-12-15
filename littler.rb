class Littler < Formula
  homepage "http://dirk.eddelbuettel.com/code/littler.html"
  # tag "math"

  head "https://github.com/eddelbuettel/littler.git"
  url "http://dirk.eddelbuettel.com/code/littler/littler-0.2.3.tar.gz"
  sha256 "98cd741c68a5c8f65b06c96d2f56d3b44979b3990335e7869b002c005ef80ba7"
  revision 2

  bottle do
    sha256 "1e5af583921af3996ad8af8605306a1dcd1f0e6d34d4e3b1b24e034e24bb12e1" => :yosemite
    sha256 "9082a86dadb7abb648c00c8f6ce811662de8b3ab0863c67e8be8e9e2fe354a8a" => :mavericks
    sha256 "6b22b34a9b733ce90ee62f90191ccc17566000d9bfe2e80161bc227aa1e63b66" => :mountain_lion
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
