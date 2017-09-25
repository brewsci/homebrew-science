class Biomake < Formula
  desc "GNU-Make-like utility for managing builds and complex workflows"
  homepage "https://github.com/evoldoers/biomake"
  url "https://github.com/evoldoers/biomake/archive/v0.1.2.tar.gz"
  sha256 "3ed91b553201b2b0aeab600f1f0795f1c02cb1cb1f19a4c0a2bb78070147b096"
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
