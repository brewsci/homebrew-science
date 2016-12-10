class Pilon < Formula
  desc "Improve draft assemblies and find variation"
  homepage "https://github.com/broadinstitute/pilon/wiki"
  url "https://github.com/broadinstitute/pilon/releases/download/v1.21/pilon-1.21.jar"
  sha256 "a57a834b8ecb468399d0c9d55b8d8aee5ecbd8310b8e245d421b6c25d6534910"
  head "https://github.com/broadinstitute/pilon.git"
  # doi "10.1371/journal.pone.0112963"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5612edbf1efa4ac46840c949f96963b8ec048a252a90b19d07de0bccc1b3d1c" => :sierra
    sha256 "f5612edbf1efa4ac46840c949f96963b8ec048a252a90b19d07de0bccc1b3d1c" => :el_capitan
    sha256 "f5612edbf1efa4ac46840c949f96963b8ec048a252a90b19d07de0bccc1b3d1c" => :yosemite
    sha256 "0ca54d343873a55d5cc4039744cdfea08b1ec56d6fd39a753a8b90f2e7cc37fd" => :x86_64_linux
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
