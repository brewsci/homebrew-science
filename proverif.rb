class Proverif < Formula
  desc "Proverif, cryptographic protocol verifier in the formal model"
  homepage "http://prosecco.gforge.inria.fr/personal/bblanche/proverif"
  url "http://prosecco.gforge.inria.fr/personal/bblanche/proverif/proverif1.92.tar.gz"
  sha256 "8c7a83dbe36ed0b5fbecf477d35769a31f8c349950aa40495e69761306048da5"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9c1a86d99a32269705b1c00ec4156e2ca051b02de1d7eca9b047c612b5800ca" => :el_capitan
    sha256 "1d17c42100fd86080e0f07ba9e7c5509a7e27d3188ba637492b9e091a4bfc99a" => :yosemite
    sha256 "53c51851f8682d7e3f8d47a1990dfcc1ac22a9a6cd59cd14f2bcb6d913352b73" => :mavericks
  end

  depends_on "ocaml"

  def install
    system "./build"

    bin.install "proverif", "proveriftotex", "spassconvert"
    doc.install Dir["docs/*"], "README", "examples"

    (prefix/"cryptoverif").install "cryptoverif.pvl"
    (share/"emacs/site-lisp/proverif").install Dir["emacs/*"]
    (prefix/"tests").install "test", "test-type"
  end

  def caveats; <<-EOS.undent
    Cryptoverif compatibility library has been installed to
    #{prefix}/cryptoverif/cryptoverif.pvl

    Extensive checks should be perfomed manually using
    #{prefix}/tests/test
    EOS
  end

  test do
    system "#{bin}/proverif", doc/"examples/horn/auth/needham"
  end
end
