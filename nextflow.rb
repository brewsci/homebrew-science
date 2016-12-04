class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "https://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  url "https://www.nextflow.io/releases/v0.22.6/nextflow"
  version "0.22.6"
  sha256 "cc2dbb316b343d02d0b4ce4f255f464e5c3510146554a0d5945623dfc2c3744d"
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
