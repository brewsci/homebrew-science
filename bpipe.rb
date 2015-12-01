class Bpipe < Formula
  desc "Platform for running bioinformatics pipelines"
  homepage "https://github.com/ssadedin/bpipe"
  # doi "10.1093/bioinformatics/bts167"
  # tag "bioinformatics"

  url "https://github.com/ssadedin/bpipe/releases/download/0.9.8.7/bpipe-0.9.8.7.tar.gz"
  sha256 "6d2b51887c8bb062c06b0cf1cb8d6331e90b9b57016f860fbceeab48a12b5c2a"
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
