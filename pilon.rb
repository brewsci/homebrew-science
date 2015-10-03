class Pilon < Formula
  desc "Improve draft assemblies and find variation"
  homepage "https://github.com/broadinstitute/pilon/wiki"
  # tag "bioinformatics"
  # doi "10.1371/journal.pone.0112963"

  url "https://github.com/broadinstitute/pilon/releases/download/v1.13/pilon-1.13.jar"
  sha256 "c6195a054acbc76afc457e6a7615f75c91adc28faeb7b8738ee2b65309b0bbe3"

  depends_on :java

  def install
    opts = "-mx1000m -ms20m"
    jar = "pilon-1.13.jar"
    java = share/"java"
    java.install jar
    bin.write_jar_script java/jar, "pilon", opts
  end

  test do
    assert_match "Pilon version", shell_output("pilon --help")
  end
end
