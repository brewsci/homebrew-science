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
    sha256 "33234927d2d50db1f5918899cfb3d7473bd9a30dc8f3acb22e86f0019da2d1d9" => :yosemite
    sha256 "cd650c5981218ddc38095a768c569973a1c60c1bfa50c6561a14e74a25a716da" => :mavericks
    sha256 "1b2646c14f6e130331b41af0668c2268a91c75a25cc7b3adf488afe289203324" => :mountain_lion
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
