class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "https://www.nextflow.io/"
  # doi "10.1038/nbt.3820"
  # tag "bioinformatics"

  url "https://www.nextflow.io/releases/v0.25.4/nextflow"
  sha256 "244bf78d450268df929a68c83a7e3c51f09236ebf02a3df1655e9a14d999d66f"
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
