class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "http://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  version "0.14.4"
  url "http://www.nextflow.io/releases/v0.14.4/nextflow"
  sha256 "cda0a2bd5777fa042102ce69a07a6543791de39919b79f6220fff561a36da4e4"

  head "https://github.com/nextflow-io/nextflow.git"

  bottle do
    cellar :any
    sha256 "69015ab04b52896a7cd546f12b8113656620ec02377f4ab2d9e715e8bda135c0" => :yosemite
    sha256 "cb54b26855345f07ff8ccaffb88b77ca201aa8c8c1c2eca9b63e17434cf8a3ec" => :mavericks
    sha256 "6802f8fae6ba32a6115110321db49495993d5313861aaf8532b981b421e8f17e" => :mountain_lion
  end

  depends_on :java => "1.7+"

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
