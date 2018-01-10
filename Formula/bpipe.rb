class Bpipe < Formula
  desc "Platform for running bioinformatics pipelines"
  homepage "https://github.com/ssadedin/bpipe"
  # doi "10.1093/bioinformatics/bts167"
  # tag "bioinformatics"

  url "http://download.bpipe.org/versions/bpipe-0.9.9.4.tar.gz"
  sha256 "0f4dfa3f96327d3e467cbebfd7690278d74f5194ec3628a2ce17e90b1064eaad"
  head "https://github.com/ssadedin/bpipe.git"

  bottle :unneeded

  depends_on :java

  def install
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bpipe -h")
  end
end
