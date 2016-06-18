class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "http://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  url "http://www.nextflow.io/releases/v0.20.1/nextflow"
  version "0.20.1"
  sha256 "02635f3371f76a10e12f7366508c90bacf532ab7c23ae03c895317a150a39bd4"

  head "https://github.com/nextflow-io/nextflow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "30edad0357e60283de15968fae40cdef93e35847d3e0bf6130dc737326aa73c8" => :el_capitan
    sha256 "347ee40489df030eba34574049aa2b52450736d823484add1a1444a53ff4cac6" => :yosemite
    sha256 "237730223a9cb46a7de5c046e6c7891322eed7185d18d868b0f3de21e656b952" => :mavericks
  end

  depends_on :java => "1.7+"

  def install
    bin.install "nextflow"
  end

  test do
    system "#{bin}/nextflow", "-download"
    system "echo", "println \'hello\' | #{bin}/nextflow -q run - |grep hello"
  end
end
