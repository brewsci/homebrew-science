require "formula"

class Nextflow < Formula
  homepage "http://www.nextflow.io/"
  head "https://github.com/nextflow-io/nextflow.git"

  depends_on :java => "1.7"

  version "0.9.0"
  url "http://www.nextflow.io/releases/v0.9.0/nextflow"
  sha1 "b4fde5c4fa81a080f9302c90924b8a0292252873"

  def install
    chmod 0755, "nextflow"
    system "./nextflow", "-download"
    bin.install "nextflow"
  end

  test do
    system "echo \"println 'hello'\" |#{bin}/nextflow -q run - |grep hello"
  end
end
