class Proverif < Formula
  desc "Proverif, cryptographic protocol verifier in the formal model"
  homepage "http://prosecco.gforge.inria.fr/personal/bblanche/proverif"
  url "http://prosecco.gforge.inria.fr/personal/bblanche/proverif/proverif1.92.tar.gz"
  sha256 "8c7a83dbe36ed0b5fbecf477d35769a31f8c349950aa40495e69761306048da5"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a313fe625cd749542822acfb78343d66c3b37aad14db581ea321625c34804a4" => :el_capitan
    sha256 "3c7ab465a96998586add43f8863e0024bbb1dab60c88ca881e14eacfa33e30b2" => :yosemite
    sha256 "43fb3b720d64812fbf9e08b21b86f8ff6b5865a6b50364f1d6637f1b5d92a424" => :mavericks
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
