class Meme < Formula
  homepage "http://meme-suite.org"
  url "http://meme-suite.org/meme-software/4.10.1/meme_4.10.1_2.tar.gz"
  sha256 "e2568d029ed7de1e2f46a48932fe72a1ac743e44795c0930a41b887c0385471c"
  version "4.10.1"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "8c5dca82cd95d3f0b42b79e4ffc0d6d5a016cf91815a89b1d4c269756a3091c1" => :yosemite
    sha256 "de1bb3015892af1de27a589b33e1f7a6859dfca537f1c34dd1831341d4b270ca" => :mavericks
    sha256 "e9e311a2ac2929bdc5d9b402dc921312c47dffb134dcefb8b56583d488b73ab2" => :mountain_lion
  end

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
