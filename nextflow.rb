require "formula"

class Nextflow < Formula
  homepage "http://www.nextflow.io/"
  head "https://github.com/nextflow-io/nextflow.git"

  depends_on :java => "1.7"

  version "0.10.1"
  url "http://www.nextflow.io/releases/v0.10.1/nextflow"
  sha1 "7dca61e75fe403f456371fc1d18ad62d6336bd1c"

  def install
    chmod 0755, "nextflow"
    system "./nextflow", "-download"
    bin.install "nextflow"
  end

  test do
    system "echo \"println 'hello'\" |#{bin}/nextflow -q run - |grep hello"
  end
end
