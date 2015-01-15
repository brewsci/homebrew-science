require "formula"

class Nextflow < Formula
  homepage "http://www.nextflow.io/"
  head "https://github.com/nextflow-io/nextflow.git"

  depends_on :java => "1.7"

  version "0.12.0"
  url "http://www.nextflow.io/releases/v0.12.0/nextflow"
  sha1 "b49a8c3348abe2136aa77fdcc3d96f5d12484506"

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
