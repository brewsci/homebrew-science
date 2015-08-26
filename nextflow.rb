class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "http://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  version "0.15.3"
  url "http://www.nextflow.io/releases/v0.15.3/nextflow"
  sha256 "d75ee8f2d17afe76486aac63e8c30905bda5228405a0507aab90724572b489b3"

  head "https://github.com/nextflow-io/nextflow.git"

  bottle do
    cellar :any
    sha256 "3b5e711d4bca4068560624d36c1b2ae76aa506c56002ca2cd4f27d0002e06edd" => :yosemite
    sha256 "736ae47d7ab394e5488b2edb8233a8a2aa25fdad8fa782844648aea00810b62c" => :mavericks
    sha256 "5a10eb5af77238eeeb8c281396a8d12d0db9a05ec5aadd8500744ba226903e4e" => :mountain_lion
  end

  depends_on :java => "1.7+"

  def install
    bin.install "nextflow"
  end

  test do
    system "#{bin}/nextflow", "-download"
    system "echo \"println 'hello'\" | #{bin}/nextflow -q run - |grep hello"
  end
end
