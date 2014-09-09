require "formula"

class Nextflow < Formula
  homepage "http://www.nextflow.io/"
  head "https://github.com/nextflow-io/nextflow.git"

  depends_on :java => "1.7"

  version "0.10.0"
  url "http://www.nextflow.io/releases/v0.10.0/nextflow"
  sha1 "4e6dc818ddf055c7c914a3c4407b1c293e5a0dbe"

  def install
    chmod 0755, "nextflow"
    system "./nextflow", "-download"
    bin.install "nextflow"
  end

  test do
    system "echo \"println 'hello'\" |#{bin}/nextflow -q run - |grep hello"
  end
end
