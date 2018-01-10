class Cryptoverif < Formula
  desc "Cryptographic protocol verifier (computational)"
  homepage "http://cryptoverif.inria.fr"
  url "http://prosecco.gforge.inria.fr/personal/bblanche/cryptoverif/cryptoverif1.22.tar.gz"
  sha256 "016730f3171076ffd8a8cb0b84eb9423e5bc7f8434025534b4ee4dadc0aecb9d"

  bottle do
    sha256 "70a19b5a89a92cb0459de738446037549d0066a7ff03332c5d528093d3286db4" => :el_capitan
    sha256 "076d41cf705165e30f4595f6d89f4f37cc8ff363c608b14f4ddfd356629f8186" => :yosemite
    sha256 "ce5eee122723cc4a72b7b817db586a8622453b3fc8c57333193059c30d80c9be" => :mavericks
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
