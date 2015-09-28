class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "http://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  version "0.15.5"
  url "http://www.nextflow.io/releases/v0.15.5/nextflow"
  sha256 "159feba94778578e215bb248175730eef606db5789581b18c078037e9b2ea4e7"

  head "https://github.com/nextflow-io/nextflow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fed8dc7ac24c509c148062dcecc3cc16f02a4203fae7d57b36b29305b62c5eb" => :el_capitan
    sha256 "77a8e1eda5c8dae83010c5cbb771c01728ed551183c10e835c4ea4b4a3007e9b" => :yosemite
    sha256 "73c55a249983a8a848c694984df83cd0e50007c189dfca54a804a9804bad7374" => :mavericks
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
