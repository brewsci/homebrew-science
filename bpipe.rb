class Bpipe < Formula
  desc "Platform for running bioinformatics pipelines"
  homepage "https://github.com/ssadedin/bpipe"
  # doi "10.1093/bioinformatics/bts167"
  # tag "bioinformatics"

  url "https://github.com/ssadedin/bpipe/releases/download/0.9.8.7/bpipe-0.9.8.7.tar.gz"
  sha256 "6d2b51887c8bb062c06b0cf1cb8d6331e90b9b57016f860fbceeab48a12b5c2a"
  head "https://github.com/ssadedin/bpipe.git"

  bottle do
    cellar :any
    sha1 "ea55f54357111679fa9ec52b750100cfbc32c6ca" => :yosemite
    sha1 "3e35a2ea71c536dd71bccbb6ed5df44bbe843952" => :mavericks
    sha1 "18a96ed694e553c8836ad48c6defa4766324289c" => :mountain_lion
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
