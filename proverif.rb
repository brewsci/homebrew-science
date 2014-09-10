require "formula"

class Proverif < Formula
  homepage "http://prosecco.gforge.inria.fr/personal/bblanche/proverif"
  url "http://prosecco.gforge.inria.fr/personal/bblanche/proverif/proverif1.88pl1.tar.gz"
  sha1 "d03d63d9ad30eaec3c6f60ab187a0da6490000ca"
  version "1.88.1"

  depends_on "objective-caml"

  def install
    system "./build"

    bin.install "proverif", "proveriftotex", "spassconvert"
    doc.install Dir["docs/*"]
    doc.install "README"
    prefix.install "examples"

    (prefix/"cryptoverif").install "cryptoverif.pvl"
    (share/"emacs"/"proverif").install Dir["emacs/*"]
    (prefix/"tests").install "test", "test-type"
  end

  test do
    system "#{bin}/proverif", "#{prefix}/examples/horn/auth/needham"
  end

  def caveats; <<-EOS.undent
    Cryptoverif compatibility library has been installed to
      #{prefix}/cryptoverif/cryptoverif.pvl

    Extensive checks should be perfomed manually using
      #{prefix}/tests/test
    EOS
  end
end
