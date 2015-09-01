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
    sha256 "caa9f41fe604c61c5ca3f3d1f043a0178de52c76241a9b0d815909c95249aba9" => :yosemite
    sha256 "d97d1b7d9dfe1e4eba625ad5228eeae7ed3353d62a964794749a63af67c57eb3" => :mavericks
    sha256 "fd912dbb05b2c52505808962e2cf4351f8dbd35a7e23ffec923eda03510b0cef" => :mountain_lion
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
