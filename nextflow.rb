class Nextflow < Formula
  homepage "http://www.nextflow.io/"
  # tag "bioinformatics"
  version "0.14.1"
  url "http://www.nextflow.io/releases/v0.14.1/nextflow"
  sha256 "08d1166ab989f7933375063389b1620e9916d6f5bc0d4a3354529236da4032c0"
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
