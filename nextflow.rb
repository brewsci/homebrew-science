class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "http://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  url "http://www.nextflow.io/releases/v0.19.4/nextflow"
  version "0.19.4"
  sha256 "ba7f177c57aafbef8a95006e3013346f6cd48ca2082373321d6c5a7df1e31a7c"

  head "https://github.com/nextflow-io/nextflow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b26e487dae12e141b47caf2bca6f8e8a99b3f08cbc8651de8914b09093a8c12" => :el_capitan
    sha256 "96dff497bafcca6a6e9b430daba591b8df3f91536895bd6fd0315fe5533aec18" => :yosemite
    sha256 "870b45582224db0bdbb93386b7b3a63d4251877dd7b770ded3de87730320b6da" => :mavericks
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
