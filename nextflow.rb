class Nextflow < Formula
  homepage "http://www.nextflow.io/"
  # tag "bioinformatics"
  version "0.13.4"
  url "http://www.nextflow.io/releases/v0.13.4/nextflow"
  sha256 "64eae8d4095dd004840afd94a4b30012b26630808adbc78aebf7445061c5271e"
  head "https://github.com/nextflow-io/nextflow.git"

  depends_on :java => "1.7+"

  def install
    bin.install "nextflow"
  end

  def post_install
    system "#{bin}/nextflow", "-download"
  end

  test do
    system "echo \"println 'hello'\" |#{bin}/nextflow -q run - |grep hello"
  end
end
