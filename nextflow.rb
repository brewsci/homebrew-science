class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "https://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  url "https://www.nextflow.io/releases/v0.22.2/nextflow"
  version "0.22.2"
  sha256 "566ff2e19c049e78132a565c7109305ab9061c6605ba3efb98e3cb92f19c905f"
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
