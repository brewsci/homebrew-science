class Trimmomatic < Formula
  desc "Flexible read trimming tool for Illumina data"
  homepage "http://www.usadellab.org/cms/?page=trimmomatic"
  url "http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.36.zip"
  sha256 "4846c42347b663b9d6d3a8cef30da2aec89fc718bf291392c58e5afcea9f70fe"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btu170"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d577a23cc018332b026bb651dc9866a0398822ebafa4eb9c2d6baa581a50a28" => :el_capitan
    sha256 "9d7d33b3dffd1955151ce5fa9178e1ca8f8fed8a74410151f36eecfb5f6508de" => :yosemite
    sha256 "1ef4c722d1ffd49272fbbcb7b31ba181241007b7940ed0cfc1b8adc8837b7569" => :mavericks
    sha256 "eaa3194a59e4ac63201a7da134d98807a645a1316ece600b390ec6888cc37b18" => :x86_64_linux
  end

  depends_on :java

  def install
    cmd = "trimmomatic"
    jar = "#{cmd}-0.36.jar"
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
