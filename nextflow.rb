class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "https://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  url "https://www.nextflow.io/releases/v0.22.3/nextflow"
  version "0.22.3"
  sha256 "906c03172c685af23282583ac976a99f1d194a798b6a2d70331bca5d9c49cad7"
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
