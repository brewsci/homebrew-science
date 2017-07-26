class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "https://www.nextflow.io/"
  # doi "10.1038/nbt.3820"
  # tag "bioinformatics"

  url "https://www.nextflow.io/releases/v0.25.2/nextflow"
  sha256 "93308b4158cf2b28b4e2875a01eb9ec2649139d279f491a467bd34c2a0290c5a"
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
