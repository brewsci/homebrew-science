class Trimmomatic < Formula
  homepage "http://www.usadellab.org/cms/?page=trimmomatic"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btu170"

  url "http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.35.zip"
  sha256 "43b993ffa91c039b529db8334bc6aa4b0d601e69c79aaa9a1457ecd1c2c3cc69"

  bottle do
    cellar :any
    sha256 "167c3b4bd6b20ea9ecd5d90c8dc03ef1b40e049b99c3b8121ea35f8549eaabf8" => :yosemite
    sha256 "a3b3a456599ab75b9ad0ef8c11cabdc35152c3c47b67f66d060599e56606b4e3" => :mavericks
    sha256 "964615ac7f4507223de6e81c1b84f8d8f73abb103f019b16b4295b940fddbcea" => :mountain_lion
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
