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
    sha256 "f5612edbf1efa4ac46840c949f96963b8ec048a252a90b19d07de0bccc1b3d1c" => :sierra
    sha256 "f5612edbf1efa4ac46840c949f96963b8ec048a252a90b19d07de0bccc1b3d1c" => :el_capitan
    sha256 "f5612edbf1efa4ac46840c949f96963b8ec048a252a90b19d07de0bccc1b3d1c" => :yosemite
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
