class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "https://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  url "https://www.nextflow.io/releases/v0.23.2/nextflow"
  version "0.23.2"
  sha256 "e8f49ce73e9ad430879ee1dbd1655497a38dc7fdb41be4bc197b15202a6ebb94"
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
