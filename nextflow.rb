class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "https://www.nextflow.io/"
  # doi "10.1038/nbt.3820"
  # tag "bioinformatics"

  url "https://www.nextflow.io/releases/v0.25.5/nextflow"
  sha256 "ac08b1b052b9709bd30411fb0ab971f644ac14847704d62800b61e18787a5885"
  head "https://github.com/nextflow-io/nextflow.git"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    bin.install "nextflow"
  end

  test do
    system bin/"nextflow", "-download"
    output = pipe_output("#{bin}/nextflow -q run -", "println 'hello'").chomp
    assert_equal "hello", output
  end
end
