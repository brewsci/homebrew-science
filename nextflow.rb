class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "http://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  url "http://www.nextflow.io/releases/v0.16.1/nextflow"
  version "0.16.1"
  sha256 "48ca9ac1f3f694478f9de4843c4bddf0a9e26abc2d27f76e6fe1081424c0d8d3"

  head "https://github.com/nextflow-io/nextflow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b65556a2e115d3e9fdba50c681ae4852577970c6d194942e2ceb6880c638e6c5" => :el_capitan
    sha256 "2f36c83e8c74e606d1ee0b6fd34fa2ac1244b0908b94515727ee56f4113468fb" => :yosemite
    sha256 "83ae58d485afac54977b0f3b4cee3642a0ba5b61fa279dc022ac57873098e508" => :mavericks
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
