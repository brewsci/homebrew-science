class Meme < Formula
  homepage "http://meme-suite.org"
  url "http://meme-suite.org/meme-software/4.10.1/meme_4.10.1_2.tar.gz"
  sha256 "e2568d029ed7de1e2f46a48932fe72a1ac743e44795c0930a41b887c0385471c"
  version "4.10.1"

  keg_only <<-EOF.undent
    MEME installs many commands, and some conflict
    with other packages.
  EOF

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install "tests"
  end

  test do
    system bin/"meme", doc/"tests/At.s"
  end
end
