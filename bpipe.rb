class Bpipe < Formula
  homepage "https://github.com/ssadedin/bpipe"
  # doi "10.1093/bioinformatics/bts167"
  # tag "bioinformatics"

  url "https://github.com/ssadedin/bpipe/releases/download/0.9.8.6/bpipe-0.9.8.6.tar.gz"
  sha1 "1c30aa068ada6b435524ef2ec031804ccade42a6"

  head "https://github.com/ssadedin/bpipe.git"

  bottle do
    cellar :any
    sha1 "ea55f54357111679fa9ec52b750100cfbc32c6ca" => :yosemite
    sha1 "3e35a2ea71c536dd71bccbb6ed5df44bbe843952" => :mavericks
    sha1 "18a96ed694e553c8836ad48c6defa4766324289c" => :mountain_lion
  end

  depends_on :java

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/bpipe"
  end
end
