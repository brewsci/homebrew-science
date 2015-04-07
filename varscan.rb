class Varscan < Formula
  homepage "http://varscan.sourceforge.net/"
  # tag "bioinformatics"
  # doi "10.1101/gr.129684.111"

  url "https://downloads.sourceforge.net/project/varscan/VarScan.v2.3.7.jar"
  sha256 "1060f823fc82a182fcc4ae5824a3639b35ff6d969657c536f709f24b2324ed12"

  depends_on :java

  def install
    jar = "VarScan.v2.3.7.jar"
    java = share/"java"
    java.install jar
    bin.write_jar_script java/jar, "varscan"
  end

  test do
    assert_match "somatic", shell_output("varscan 2>&1", 0)
    assert_match "min-coverage", shell_output("varscan filter -h 2>&1", 0)
  end
end
