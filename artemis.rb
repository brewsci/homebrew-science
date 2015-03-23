class Artemis < Formula
  homepage "http://www.sanger.ac.uk/resources/software/artemis"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btr703"
  # head "https://github.com/sanger-pathogens/Artemis"

  url "ftp://ftp.sanger.ac.uk/pub/resources/software/artemis/v16/v16.0.11/artemis_v16.0.11.jar"
  sha256 "f368714105646cfc31460cfcfb72b8b33490c7684ee5323d7dd181060039c80f"

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

  # No test block because these tools are GUI only
end
