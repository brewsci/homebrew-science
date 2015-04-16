class Nextflow < Formula
  homepage "http://www.nextflow.io/"
  # tag "bioinformatics"
  version "0.13.2"
  url "http://www.nextflow.io/releases/v0.13.2/nextflow"
  sha256 "c06d98ee74b14ed16dc5d38faf89eb0019f1524a501126cfe8d8bd67024a7d22"
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
