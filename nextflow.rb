class Nextflow < Formula
  homepage "http://www.nextflow.io/"
  # tag "bioinformatics"
  version "0.14.0"
  url "http://www.nextflow.io/releases/v0.14.0/nextflow"
  sha256 "26f50c8f459068f91a625ea71c64d5168e798279b4a56060734422e04102e1f0"
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
