class Cryptoverif < Formula
  desc "Cryptographic protocol verifier (computational)"
  homepage "http://cryptoverif.inria.fr"
  url "http://prosecco.gforge.inria.fr/personal/bblanche/cryptoverif/cryptoverif1.22.tar.gz"
  sha256 "016730f3171076ffd8a8cb0b84eb9423e5bc7f8434025534b4ee4dadc0aecb9d"

  bottle do
    sha256 "d95da63effd59ea2faae1376907e089468dcd4a132fb86a7f042501c4e0d6348" => :el_capitan
    sha256 "991b6f79e5bc6f78d46141c82449d3fe9dd51fd0c581bb3cb3428fc915985526" => :yosemite
    sha256 "d65f87242e90e1ecb9b2635a563d32f31fd8e355b74ce6b8bedef5210af2cec2" => :mavericks
  end

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
