class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "https://www.nextflow.io/"
  # doi "10.1038/nbt.3820"
  # tag "bioinformatics"

  url "https://www.nextflow.io/releases/v0.26.0/nextflow"
  sha256 "dd0cec126373542cb2d6e1d2ea10513780547accf44af6d8364e19da9e93aee2"
  head "https://github.com/nextflow-io/nextflow.git"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    bin.install "nextflow"
  end

  test do
    system bin/"nextflow", "-download"
    output = pipe_output("#{bin}/nextflow -q run -", "println 'hello'").chomp
    assert_equal "hello", output
  end
end
