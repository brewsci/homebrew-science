class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "http://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  url "http://www.nextflow.io/releases/v0.16.5/nextflow"
  version "0.16.5"
  sha256 "c2dd8c0cd4503e37705842e67185fb4d0027a658e7d258d45630628f6e854922"

  head "https://github.com/nextflow-io/nextflow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0465957e15347de1ccd76188f9719e006cc00c368f88ebd85013f5ccadf96fd7" => :el_capitan
    sha256 "d0dbf1e46ea6e7c4560954e44e1f110f9b7d31d29aca6eff5b7a78865a6dbd9a" => :yosemite
    sha256 "d0dbf1e46ea6e7c4560954e44e1f110f9b7d31d29aca6eff5b7a78865a6dbd9a" => :mavericks
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
