class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "https://www.nextflow.io/"
  # doi "10.1038/nbt.3820"
  # tag "bioinformatics"

  url "https://www.nextflow.io/releases/v0.26.2/nextflow"
  sha256 "5056ff2ecf437c53af440251af553dc2cac64e00758c94c8937a7e787ed0bbe0"
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
