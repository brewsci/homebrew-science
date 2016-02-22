class Trimmomatic < Formula
  homepage "http://www.usadellab.org/cms/?page=trimmomatic"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btu170"

  url "http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.35.zip"
  sha256 "43b993ffa91c039b529db8334bc6aa4b0d601e69c79aaa9a1457ecd1c2c3cc69"

  bottle do
    cellar :any_skip_relocation
    sha256 "53d19260547f5d00f87422d097804c5930699c02127dbb5dfccae938024bd5f5" => :el_capitan
    sha256 "fffbb3c9f603e40f9e298e7d2325be7189c9fa47f16e7ee61e5240a95df6fa8f" => :yosemite
    sha256 "d96df900066f157486314c08386f1a4d61e944476b0488abd38e40c6df2064ca" => :mavericks
  end

  depends_on :java

  def install
    cmd = "trimmomatic"
    jar = "#{cmd}-0.35.jar"
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
