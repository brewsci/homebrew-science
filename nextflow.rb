class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "http://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  url "http://www.nextflow.io/releases/v0.20.0/nextflow"
  version "0.20.0"
  sha256 "7d35fb563be2cdb672d211ca8459b662651255a27daf24555085cce60ad8f95f"

  head "https://github.com/nextflow-io/nextflow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8cae092d98edc2d58a7a7303a3bc4f23f56a743b084311383dc049f9b4fc7402" => :el_capitan
    sha256 "d0cc6acab817026d45380a507d9d0ca400daccda997d40bb2468718679a531a5" => :yosemite
    sha256 "fa7f382bb236c334a3f02591a343be030456e963b154b3102fa34596857c2290" => :mavericks
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
