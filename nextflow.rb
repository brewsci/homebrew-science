require "formula"

class Nextflow < Formula
  homepage "http://www.nextflow.io/"
  head "https://github.com/nextflow-io/nextflow.git"

  version "0.8.3"
  url "http://www.nextflow.io/releases/v0.8.3/nextflow"
  sha1 "e93c2f6eb8d4ff045e6934e1753d546f68daffbf"

  def install
    chmod 0755, "nextflow"
    system "./nextflow", "-download"
    bin.install "nextflow"
  end

  test do
    system "echo \"println 'hello'\" | #{bin}/nextflow -q | grep -q hello"
  end
end
