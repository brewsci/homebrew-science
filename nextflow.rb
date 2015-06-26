class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "http://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  version "0.14.2"
  url "http://www.nextflow.io/releases/v0.14.2/nextflow"
  sha256 "26b7f29c3682173900290b664a8e3e9e0cdb98553317345842e524bd033c2a3d"

  head "https://github.com/nextflow-io/nextflow.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "a63c9eeb236de4d38bf14b3c5ae84d054c16335c9afeee85274eee914c1c7956" => :yosemite
    sha256 "0233a03b52b2e2cef07922ad4a3166b0895ac193d48904e9f95662d5ffd1185d" => :mavericks
    sha256 "f6a838b641fac81bb55df883d01f41985af753ac1a6ba1ddb916732a1c72b2c9" => :mountain_lion
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
