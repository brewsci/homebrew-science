class Bpipe < Formula
  desc "Platform for running bioinformatics pipelines"
  homepage "https://github.com/ssadedin/bpipe"
  # doi "10.1093/bioinformatics/bts167"
  # tag "bioinformatics"

  url "https://github.com/ssadedin/bpipe/releases/download/0.9.9.0/bpipe-0.9.9.tar.gz"
  sha256 "3a45abd20cfd563ec68da50589df0310a46c60efeefbe486ba20dede844765e4"
  head "https://github.com/ssadedin/bpipe.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b7bc1bf58deba168b0c3224e5f359a3b69abaac69484d14c780adc988ad06ed" => :el_capitan
    sha256 "4f1072819acc24c91e9127038853b0458ac6b714992cbe9e9cd08e33366763a1" => :yosemite
    sha256 "4ebf31154059aad19922532b4e15ce2c3c0e899ec28edae7e196b25ae0ed8e7a" => :mavericks
    sha256 "fc4fbddefa999ecc2c3f2ac57a1c1296b11f50ed5cb168403f22a44194875072" => :x86_64_linux
  end

  depends_on :java

  def install
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Found 0 currently executing commands", shell_output("#{bin}/bpipe status")
  end
end
