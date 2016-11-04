class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "https://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  url "https://www.nextflow.io/releases/v0.22.4/nextflow"
  version "0.22.4"
  sha256 "01f1473b6e05b10fa02cbc39fe38665987d71873cd1c1e1d875ba9066f65e6ef"
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
