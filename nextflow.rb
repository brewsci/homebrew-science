class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "http://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  url "http://www.nextflow.io/releases/v0.16.2/nextflow"
  version "0.16.2"
  sha256 "b57a8a73195e1f6e6c0a81621361869c11d29d8825e6540897ef6ab74667d5d1"

  head "https://github.com/nextflow-io/nextflow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ad601e556e4faf982f6b545df66e0f6f824c66fe29dfc3259e686681d2d1e20" => :el_capitan
    sha256 "be31172f43b96ccd2e9c9739660954f215eb5331e690e1a01288226a57dbf599" => :yosemite
    sha256 "0da69adb239829f6d5c0090bf47af5ea0cbc3c41e9f566d27664709c4b679647" => :mavericks
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
