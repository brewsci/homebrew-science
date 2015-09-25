class Proverif < Formula
  desc "Proverif, cryptographic protocol verifier in the formal model"
  homepage "http://prosecco.gforge.inria.fr/personal/bblanche/proverif"
  url "http://prosecco.gforge.inria.fr/personal/bblanche/proverif/proverif1.91.tar.gz"
  sha256 "ea2310199f2814da294572adc58a27edc7e1342a178859badd3cab01ce804ad2"

  bottle do
    cellar :any
    sha256 "60d688d67296523154187081ba6bc046481f0995eb2253fff34cf1416bc7db1b" => :yosemite
    sha256 "bbca3ce1cb0a4d0f4ebb75e9d3cf5758beee768dee481d3571e97b32979b6687" => :mavericks
    sha256 "f7ccdb5ba4c721f6316ea67287c6e13c6c852826f95c44b1659a6936a1e7abb1" => :mountain_lion
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
