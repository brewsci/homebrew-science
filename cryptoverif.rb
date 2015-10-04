class Cryptoverif < Formula
  desc "Cryptographic protocol verifier (computational)"
  homepage "http://cryptoverif.inria.fr"
  url "http://prosecco.gforge.inria.fr/personal/bblanche/cryptoverif/cryptoverif1.21.tar.gz"
  sha256 "c20077f0753af1a3e9c5d4231f3e7f6ae885451c2432eadc13faaf28351b8143"

  depends_on "ocaml"

  def install
    system "./build"

    bin.install "cryptoverif"
    doc.install Dir["docs/*"], "README", "CHANGES", "implementation"

    (share/"emacs/site-lisp/cryptoverif").install Dir["emacs/*"]
    (libexec/"stdlib").install "default.cvl", "default.ocvl"
    (libexec/"tests").install "test"
    libexec.install "examples", "oexamples", "authexamples"

    mkdir_p "#{libexec}/tests/tests"
    touch "#{libexec}/tests/tests/hw"
    ln_s "#{bin}/cryptoverif", "#{libexec}/tests/cryptoverif"
    ln_s "#{libexec}/examples", "#{libexec}/tests/examples"
    ln_s "#{libexec}/oexamples", "#{libexec}/tests/oexamples"
    ln_s "#{libexec}/authexamples", "#{libexec}/tests/authexamples"
    ln_s "#{libexec}/stdlib/default.cvl", "#{libexec}/tests/default.cvl"
    ln_s "#{libexec}/stdlib/default.ocvl", "#{libexec}/tests/default.ocvl"

    prefix.install_symlink libexec/"stdlib"
    prefix.install_symlink libexec/"tests"
    prefix.install_symlink libexec/"examples"
    prefix.install_symlink libexec/"oexamples"
    prefix.install_symlink libexec/"authexamples"
  end

  def caveats; <<-EOS.undent
    Cryptoverif can be manually aliased to include the default lib:
    - alias cryptoverif='cryptoverif -lib #{prefix}/stdlib/default'

    Extensive checks can be perfomed manually using:
    - #{prefix}/test
    EOS
  end

  test do
    system "#{bin}/cryptoverif", "-lib", "#{prefix}/stdlib/default", "#{prefix}/examples/encrypt-then-MAC.cv"
  end
end
