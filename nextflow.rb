class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "https://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  url "https://www.nextflow.io/releases/v0.23.0/nextflow"
  version "0.23.0"
  sha256 "096fecdf19788bada4beef488de010f9a218ab4b48a6762d7b910e1b47db1456"
  head "https://github.com/nextflow-io/nextflow.git"

  bottle :unneeded

  depends_on java: "1.7+"

  def install
    bin.install "nextflow"
  end

  test do
    system bin/"nextflow", "-download"
    output = pipe_output("#{bin}/nextflow -q run -", "println 'hello'").chomp
    assert_equal "hello", output
  end
end
