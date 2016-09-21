class Pilon < Formula
  desc "Improve draft assemblies and find variation"
  homepage "https://github.com/broadinstitute/pilon/wiki"
  url "https://github.com/broadinstitute/pilon/releases/download/v1.20/pilon-1.20.jar"
  sha256 "9ae5d8a5a1a369e569da02e2f00ee0a6628c0539d7ac7fd376e94707bb2ef680"
  head "https://github.com/broadinstitute/pilon.git"
  # doi "10.1371/journal.pone.0112963"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d0ef53b1593729bfb1699c541d92679e350ccf329f4b9345965778c1742d8f0" => :el_capitan
    sha256 "d09447178b800403b14b89a138a6a57280c4abe68eab40a343bdf2dc38fa53fc" => :yosemite
    sha256 "40061af656772107896ac883d514f5c3d01fe8bf36e95dfe5db501a2c32539fa" => :mavericks
    sha256 "186e0a48307827f4a2be1f1edf98138c5e74b0507eae71ad0e99d484bab49214" => :x86_64_linux
  end

  depends_on :java

  def install
    opts = "-mx1000m -ms20m"
    jar = "pilon-#{version}.jar"
    prefix.install jar
    bin.write_jar_script prefix/jar, "pilon", opts
  end

  test do
    assert_match "Usage", shell_output("#{bin}/pilon --help")
  end
end
