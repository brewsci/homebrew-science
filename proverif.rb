class Proverif < Formula
  homepage "http://prosecco.gforge.inria.fr/personal/bblanche/proverif"
  url "http://prosecco.gforge.inria.fr/personal/bblanche/proverif/proverif1.89.tar.gz"
  sha256 "985a2b1a82e358c32b71b707ef915ca8204c3e3584504fb2188025410ce30660"

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
