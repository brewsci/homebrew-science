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
    sha256 "36a96e3b9ea1e381cca6962345a205ceaa36eb0fe97b3acb03d6836826ce8451" => :yosemite
    sha256 "5ecc8d67f38a5a4ef08fdbbed7136b4f10b98aba0b8bfefaf50dc7f29622e528" => :mavericks
    sha256 "be4b953b7de193274c88824f075c240d14d9eb4a5cb05615a61ddbd5271df19e" => :mountain_lion
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
