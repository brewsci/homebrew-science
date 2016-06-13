class Varscan < Formula
  desc "Variant detection in massively parallel sequencing data"
  homepage "http://varscan.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/varscan/VarScan.v2.3.7.jar"
  sha256 "1060f823fc82a182fcc4ae5824a3639b35ff6d969657c536f709f24b2324ed12"
  # doi "10.1101/gr.129684.111"
  # tag "bioinformatics"

  bottle :unneeded

  depends_on :java

  def install
    jar = "VarScan.v2.3.7.jar"
    java = share/"java"
    java.install jar
    bin.write_jar_script java/jar, "varscan"
  end

  test do
    assert_match "somatic", shell_output("#{bin}/varscan 2>&1", 0)
    assert_match "min-coverage", shell_output("#{bin}/varscan filter -h 2>&1", 0)
  end
end
