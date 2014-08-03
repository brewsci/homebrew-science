require "formula"

class Nextflow < Formula
  homepage "http://www.nextflow.io/"
  head "https://github.com/nextflow-io/nextflow.git"
  
  depends_on :java => "1.7"
  
  version "0.8.5"
  url "http://www.nextflow.io/releases/v0.8.5/nextflow"
  sha1 "e7d1746041782af402623a1ed0f20a747f524da7"

  def install
    chmod 0755, "nextflow"
    system "./nextflow", "-download"
    bin.install "nextflow"
  end

  test do
    system "echo \"println 'hello'\" | #{bin}/nextflow -q | grep -q hello"
  end
end
