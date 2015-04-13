class Nextflow < Formula
  homepage "http://www.nextflow.io/"
  # tag "bioinformatics"
  version "0.13.1"
  url "http://www.nextflow.io/releases/v0.13.1/nextflow"
  sha1 "ddcae0ac62ae4dc17259a1ceace69ee7c2483cf4"
  head "https://github.com/nextflow-io/nextflow.git"

  depends_on :java => "1.7"

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
