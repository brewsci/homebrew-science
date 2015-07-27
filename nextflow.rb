class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "http://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  version "0.15.0"
  url "http://www.nextflow.io/releases/v0.15.0/nextflow"
  sha256 "1d1b56eb363b74b87c1bce1a04895f3c2f151be8be0903d0998aaf7d10f0cc0e"

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
