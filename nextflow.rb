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
    sha256 "c3ec887e42ae7a187feb44ee560d2735fb62b7b0cbf36d8f0f55c8b0c0f98938" => :el_capitan
    sha256 "9ac866573a0921cdc5e18b1d08ae170b906d51e64929e5865d762c9456f53a5d" => :yosemite
    sha256 "0badefa5892f71068e89284cbd76d07b993e37b356e9ac2588eda30a6e332da5" => :mavericks
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
