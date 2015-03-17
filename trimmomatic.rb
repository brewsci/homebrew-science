
class Trimmomatic < Formula
  homepage "http://www.usadellab.org/cms/?page=trimmomatic"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btu170"

  url "http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.33.zip"
  sha256 "6968583a6c5854a44fff7d427e7ccdcb8dc17f4616082dd390a0633f87a09e3d"

  depends_on :java

  def install
    cmd = "trimmomatic"
    jar = "#{cmd}-0.33.jar"
    java = share/"java"
    java.install jar
    bin.write_jar_script java/jar, cmd
    doc.install "LICENSE"
    adapters = share/cmd/"adapters"
    adapters.install Dir["adapters/*"]
  end

  def caveats
    <<-EOS.undent
      The Trimmomatic FASTA adapter files can be found in
        #{HOMEBREW_PREFIX}/share/trimmomatic/adapters
    EOS
  end

  test do
    # has return code 1 when showing default help
    assert_match "trimmer", shell_output("#{bin}/trimmomatic 2>&1", 1)
  end
end
