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
    sha256 "2373339c1200f7346c75803119bcecdb5b78f492bc1da20bf86735e6d7930b67" => :el_capitan
    sha256 "d5a3e2133ca77eb080640d45fa7300bbfbea2cdd7bbb3e7178ce26f338c783d5" => :yosemite
    sha256 "b9e5a29ee76d1076e9618dabfa9df685c678a5734167ce86ad2d36ce28777f46" => :mavericks
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
