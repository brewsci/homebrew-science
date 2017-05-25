class Bpipe < Formula
  desc "Platform for running bioinformatics pipelines"
  homepage "https://github.com/ssadedin/bpipe"
  # doi "10.1093/bioinformatics/bts167"
  # tag "bioinformatics"

  url "http://download.bpipe.org/versions/bpipe-0.9.9.3.tar.gz"
  sha256 "414d781c14d770cca0ddd4077fe82f30d691f19c7980aa8f1773f77c1cfddf08"
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
