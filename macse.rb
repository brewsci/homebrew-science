class Macse < Formula
  desc "Multiple Alignment of Coding SEquences"
  homepage "http://bioweb.supagro.inra.fr/macse/"
  # doi "10.1371/journal.pone.0022594"
  # tag "bioinformatics"

  url "http://bioweb.supagro.inra.fr/macse/releases/macse_v1.2.jar"
  sha256 "5545afd948cc4cd8af435ad9b29c78f77226b73c505b4a42cf938aad0d256803"

  depends_on :java

  def install
    opts = "-mx4000m -ms80m"
    jar = "macse_v#{version}.jar"
    prefix.install jar
    bin.write_jar_script prefix/jar, "macse", opts
  end

  test do
    assert_match "Thraustochytrium", shell_output("#{bin}/macse", 1)
  end
end
