class Biomake < Formula
  desc "GNU-Make-like utility for managing builds and complex workflows"
  homepage "https://github.com/evoldoers/biomake"
  url "https://github.com/evoldoers/biomake/archive/v0.1.0.tar.gz"
  sha256 "fc82ca41449b39ecb124928f630a6e65e36250a7dcd4b978729310b3c21e640f"
  head "https://github.com/evoldoers/biomake.git"
  # doi "10.1101/093245"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "ceeab5810cabdad92c4a610d7b31177dc086b8dbcf076a0c54a7e2c85a45a912" => :sierra
    sha256 "c5e69a4f25172f4a1c1148898852377e507794e48bdd1e91c46dd8a256d55e90" => :el_capitan
    sha256 "c5e69a4f25172f4a1c1148898852377e507794e48bdd1e91c46dd8a256d55e90" => :yosemite
    sha256 "8cc8b040fa58b8cb784e883fe3e1caa1c46b89274c829da3701082608bde0dbf" => :x86_64_linux
  end

  depends_on "swi-prolog"

  def install
    inreplace "bin/biomake", "$PATH_TO_ME/swipl", "swipl"
    rm ["bin/swipl", "Makefile"]
    rm_r "t"
    prefix.install Dir["*"]
  end

  test do
    assert_match "Options", shell_output("#{bin}/biomake -h")
    (testpath/"Makefile").write "default: ; echo Homebrew"
    assert_match /^Homebrew$/, shell_output("#{bin}/biomake")
  end
end
