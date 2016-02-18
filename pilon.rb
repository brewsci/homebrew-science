class Pilon < Formula
  desc "Improve draft assemblies and find variation"
  homepage "https://github.com/broadinstitute/pilon/wiki"
  # tag "bioinformatics"
  # doi "10.1371/journal.pone.0112963"

  url "https://github.com/broadinstitute/pilon/releases/download/v1.16/pilon-1.16.jar"
  sha256 "49d2fef3343c2759a0e6d7b22bdbf9c6acdb0a1f77ebbadba1c9cf94f2e9f4e6"

  bottle :unneeded

  depends_on :java

  def install
    opts = "-mx1000m -ms20m"
    jar = "pilon-#{version}.jar"
    prefix.install jar
    bin.write_jar_script prefix/jar, "pilon", opts
  end

  test do
    assert_match "Pilon version", shell_output("pilon --help")
  end
end
