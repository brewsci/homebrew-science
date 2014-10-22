require "formula"

class Nextflow < Formula
  homepage "http://www.nextflow.io/"
  head "https://github.com/nextflow-io/nextflow.git"

  depends_on :java => "1.7"

  version "0.10.3"
  url "http://www.nextflow.io/releases/v0.10.3/nextflow"
  sha1 "d13888b89421f54065ba64fff87a47613554727d"

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
