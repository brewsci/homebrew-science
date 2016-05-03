class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "http://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  url "http://www.nextflow.io/releases/v0.18.2/nextflow"
  version "0.18.2"
  sha256 "1e372c25217f7fad759ae499225302fc43c68dbfe1103dac2e5520d363de3227"

  head "https://github.com/nextflow-io/nextflow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "87ab47b109b6017f5e72690966e0948286d807eaea700d500a8ed7bfc2c02a60" => :el_capitan
    sha256 "47b5d6129ad6913ebf11d66dc8a05359a4a53d295cbb82a87f7cba13f8ac6184" => :yosemite
    sha256 "edd6e7fdf175c5e9add1bb28b560b86cae3d94135d9c2d7388eda40b7b636ed2" => :mavericks
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
