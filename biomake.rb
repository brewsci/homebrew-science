class Biomake < Formula
  desc "GNU-Make-like utility for managing builds and complex workflows"
  homepage "https://github.com/evoldoers/biomake"
  url "https://github.com/evoldoers/biomake/archive/v0.1.3.tar.gz"
  sha256 "98c10a85834955b656e1f78ddc3f3adde78b1321472a7d91f70827b8a7b81f48"
  head "https://github.com/evoldoers/biomake.git"
  # doi "10.1101/093245"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d4d692c775761ffc7ae14b2e53796aa973752855172f11e85441e90b8269c2f" => :high_sierra
    sha256 "8d4d692c775761ffc7ae14b2e53796aa973752855172f11e85441e90b8269c2f" => :sierra
    sha256 "8d4d692c775761ffc7ae14b2e53796aa973752855172f11e85441e90b8269c2f" => :el_capitan
    sha256 "578c9fd0bab410bd697bf6a8f69f3c8c6cbab87e9a4fc00457e95b38a50cb82e" => :x86_64_linux
  end

  depends_on "swi-prolog"

  def install
    inreplace "bin/biomake", "$PATH_TO_ME/swipl_wrap", "swipl"
    rm ["bin/swipl_wrap", "Makefile"]
    rm_r "t"
    prefix.install Dir["*"]
  end

  test do
    assert_match "Options", shell_output("#{bin}/biomake -h")
    (testpath/"Makefile").write "default: ; echo Homebrew"
    assert_match /^Homebrew$/, shell_output("#{bin}/biomake")
  end
end
