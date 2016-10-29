class Bpipe < Formula
  desc "Platform for running bioinformatics pipelines"
  homepage "https://github.com/ssadedin/bpipe"
  # doi "10.1093/bioinformatics/bts167"
  # tag "bioinformatics"

  url "https://github.com/ssadedin/bpipe/releases/download/0.9.9.2/bpipe-0.9.9.2.tar.gz"
  sha256 "29986da8dfb89d9789c25d3bf7e3486acfd99eb1fbac887e7f3aebc8e07ee471"
  head "https://github.com/ssadedin/bpipe.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5cbbd4b15a4ea1a73266a82ad9e47747ac745600e331c7abbef3033958d2b2a0" => :el_capitan
    sha256 "af2b2242a3a04786cd46acfbf56c21a83330d78bf969c49db6cf7be22f62404d" => :yosemite
    sha256 "670604584ce9f32afcad449840fdc4294b228b60c315d5bdc178e6b8d07fc64e" => :mavericks
    sha256 "5207240e3fbe3182f447f6a08b5407715047d749fdb03967f39a2b5535334095" => :x86_64_linux
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
