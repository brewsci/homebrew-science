class Pilon < Formula
  desc "Improve draft assemblies and find variation"
  homepage "https://github.com/broadinstitute/pilon/wiki"
  url "https://github.com/broadinstitute/pilon/releases/download/v1.18/pilon-1.18.jar"
  sha256 "50589a96576101ccd68ba89e08e08fe7465cec8129757e3213b52b9ce88a0059"
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
