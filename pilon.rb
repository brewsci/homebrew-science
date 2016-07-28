class Pilon < Formula
  desc "Improve draft assemblies and find variation"
  homepage "https://github.com/broadinstitute/pilon/wiki"
  url "https://github.com/broadinstitute/pilon/releases/download/v1.17/pilon-1.17.jar"
  sha256 "3c68c660363bec6865ded39b4b9008b452d7cfffab1fecaccd92896d9a2fbd14"
  head "https://github.com/broadinstitute/pilon.git"
  # doi "10.1371/journal.pone.0112963"
  # tag "bioinformatics"

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
