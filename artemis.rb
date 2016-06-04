class Artemis < Formula
  desc "Genome browser and annotation tool"
  homepage "http://www.sanger.ac.uk/science/tools/artemis"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btr703"
  # head "https://github.com/sanger-pathogens/Artemis"

  url "ftp://ftp.sanger.ac.uk/pub/resources/software/artemis/v16/v16.0.11/artemis_v16.0.11.jar"
  sha256 "f368714105646cfc31460cfcfb72b8b33490c7684ee5323d7dd181060039c80f"

  bottle do
    cellar :any
    sha256 "f820d56e5b383d2c9b8d4525229034aea0185e195104be6cc6ad2036bf31a7b0" => :yosemite
    sha256 "49bd7b5ad6c279fd05ceb484ad75386284ecf5f9e4c520899b6f589d3d2af46a" => :mavericks
    sha256 "e74ad576452d26d85453d30cd2efaf0259cb5e2e0689ec2de6ead93df36cb69e" => :mountain_lion
    sha256 "5a80a0cc948cc31f4fade5255aa7c5197a732d42172574a416025d9401f01332" => :x86_64_linux
  end

  depends_on :java

  def install
    opts = "-mx1000m -ms20m"
    jar = "artemis_v16.0.11.jar"
    java = share/"java"
    java.install jar

    bin.write_jar_script java/jar, "art", opts
    inreplace bin/"art", "-jar", "-cp"
    inreplace bin/"art", '"$@"', 'uk.ac.sanger.artemis.components.ArtemisMain "$@"'

    bin.write_jar_script java/jar, "act", opts
    inreplace bin/"act", "-jar", "-cp"
    inreplace bin/"act", '"$@"', 'uk.ac.sanger.artemis.components.ActMain "$@"'

    bin.write_jar_script java/jar, "dnaplotter", opts
    inreplace bin/"dnaplotter", "-jar", "-cp"
    inreplace bin/"dnaplotter", '"$@"', 'uk.ac.sanger.artemis.circular.DNADraw "$@"'
  end

  test do
    # No test block because these tools are GUI only
  end
end
