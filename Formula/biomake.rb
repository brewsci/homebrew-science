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
    sha256 "939df967495a5ead01e701c34e661309ad80ac56230685148b116092aa04f795" => :high_sierra
    sha256 "939df967495a5ead01e701c34e661309ad80ac56230685148b116092aa04f795" => :sierra
    sha256 "939df967495a5ead01e701c34e661309ad80ac56230685148b116092aa04f795" => :el_capitan
    sha256 "dd1b66dd4f9f4eb450be66740b263e0b44738e1517c4428180f753a66308a8b3" => :x86_64_linux
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
