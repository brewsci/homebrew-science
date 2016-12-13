class Biomake < Formula
  desc "GNU-Make-like utility for managing builds and complex workflows"
  homepage "https://github.com/evoldoers/biomake"
  url "https://github.com/evoldoers/biomake/archive/v0.1.0.tar.gz"
  sha256 "fc82ca41449b39ecb124928f630a6e65e36250a7dcd4b978729310b3c21e640f"
  head "https://github.com/evoldoers/biomake.git"
  # doi "10.1101/093245"
  # tag "bioinformatics"

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
