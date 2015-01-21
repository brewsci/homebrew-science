class Bpipe < Formula
  homepage "https://github.com/ssadedin/bpipe"
  # doi "10.1093/bioinformatics/bts167"
  # tag "bioinformatics"

  url "https://github.com/ssadedin/bpipe/releases/download/0.9.8.6/bpipe-0.9.8.6.tar.gz"
  sha1 "1c30aa068ada6b435524ef2ec031804ccade42a6"

  head "https://github.com/ssadedin/bpipe.git"

  depends_on :java

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/bpipe"
  end
end
