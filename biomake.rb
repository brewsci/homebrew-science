class Biomake < Formula
  desc "GNU-Make-like utility for managing builds and complex workflows"
  homepage "https://github.com/evoldoers/biomake"
  url "https://github.com/evoldoers/biomake/archive/v0.1.1.tar.gz"
  sha256 "9e31b5033b71f1d8defb77163107560263786797d5a692802dba962f50185ca5"
  head "https://github.com/evoldoers/biomake.git"
  # doi "10.1101/093245"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "f59ee70969d5a46cca2965f364f47a22e0b847379fa230b5c936a7cfc2eaa287" => :sierra
    sha256 "f59ee70969d5a46cca2965f364f47a22e0b847379fa230b5c936a7cfc2eaa287" => :el_capitan
    sha256 "f59ee70969d5a46cca2965f364f47a22e0b847379fa230b5c936a7cfc2eaa287" => :yosemite
    sha256 "64cdc3e28cfd3c0d173163324100952547e8c806efd3626ec559979908bd5273" => :x86_64_linux
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
