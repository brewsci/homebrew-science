class Artemis < Formula
  desc "Genome browser and annotation tool"
  homepage "https://www.sanger.ac.uk/science/tools/artemis"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btr703"
  # head "https://github.com/sanger-pathogens/Artemis"

  url "ftp://ftp.sanger.ac.uk/pub/resources/software/artemis/v16/v16.0.17/artemis-v16.0.17.jar"
  sha256 "c3b4cb232e75912d1a439fe526666759fa4ef92bcd0070972f4c09fcb58d9b0c"

  bottle :unneeded

  depends_on :java

  def install
    opts = "-mx1000m -ms20m"
    jar = "artemis-v#{version}.jar"
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
