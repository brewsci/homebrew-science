class Littler < Formula
  homepage "http://dirk.eddelbuettel.com/code/littler.html"
  # tag "math"

  head "https://github.com/eddelbuettel/littler.git"
  url "http://dirk.eddelbuettel.com/code/littler/littler-0.2.3.tar.gz"
  sha256 "98cd741c68a5c8f65b06c96d2f56d3b44979b3990335e7869b002c005ef80ba7"
  revision 1

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "5555cb0b3e80495e434e90096ea611adb278fabb45b0af234c84b88fbfc4468e" => :yosemite
    sha256 "83a8a50ec9d4296e3b14542d5b2670260c998aec0c88489e2630286948661e09" => :mavericks
    sha256 "be4c9192a9f8ef6096f148459c3c2fc9ecdd7ffe2ec5cd22619a962d0585a28f" => :mountain_lion
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
