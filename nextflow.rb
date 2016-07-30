class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "http://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  url "http://www.nextflow.io/releases/v0.21.1/nextflow"
  version "0.21.1"
  sha256 "29eac008af0eea6008ee77439792646cb438f7b47728ade723ff174d93f19c80"
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
