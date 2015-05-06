class Proverif < Formula
  homepage "http://prosecco.gforge.inria.fr/personal/bblanche/proverif"
  url "http://prosecco.gforge.inria.fr/personal/bblanche/proverif/proverif1.89.tar.gz"
  sha256 "985a2b1a82e358c32b71b707ef915ca8204c3e3584504fb2188025410ce30660"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "90d02aabbc2df37bf61f6486c030e2d91968eccd6c76e7db55e58ac4c0eeffcc" => :yosemite
    sha256 "4bcf183ee2bd750cd732d54c250cf4e978707aba28b01bb05d5194999eee9f62" => :mavericks
    sha256 "3765f3715e03aee2ffe1eb8c7f17c4efc865af62455271762c6c337a5deba134" => :mountain_lion
  end

  depends_on "objective-caml"

  def install
    system "./build"

    bin.install "proverif", "proveriftotex", "spassconvert"
    doc.install Dir["docs/*"], "README", "examples"

    (prefix/"cryptoverif").install "cryptoverif.pvl"
    (share/"emacs/site-lisp").install Dir["emacs/*"]
    (prefix/"tests").install "test", "test-type"
  end

  test do
    system "#{bin}/proverif", doc/"examples/horn/auth/needham"
  end

  def caveats; <<-EOS.undent
    Cryptoverif compatibility library has been installed to
      #{prefix}/cryptoverif/cryptoverif.pvl

    Extensive checks should be perfomed manually using
      #{prefix}/tests/test
    EOS
  end
end
