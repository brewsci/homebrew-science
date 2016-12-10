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
    sha256 "7f7110ffce96e0450c7ff7a01b6e3cbac674279c749575da30378b9c1253fe01" => :sierra
    sha256 "2e5982b24f64ced9fa4e4926d984a7efcbef8f827399b04e9c1f9dcd4e33acd8" => :el_capitan
    sha256 "2e5982b24f64ced9fa4e4926d984a7efcbef8f827399b04e9c1f9dcd4e33acd8" => :yosemite
    sha256 "057c17297c13f3977fa8452f9ebbfc02cc9de4d1966c2db1b3e93f6aa500b1d9" => :x86_64_linux
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
