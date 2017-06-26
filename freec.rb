class Freec < Formula
  desc "Copy number and genotype annotation in whole genome/exome sequencing data"
  homepage "http://bioinfo.curie.fr/projects/freec/"
  url "https://github.com/BoevaLab/FREEC/archive/v10.8.tar.gz"
  sha256 "8b29a7432aa00d09a1443b20fc07e58494292da6c96de518b71e279c6da931a6"
  head "https://github.com/BoevaLab/FREEC.git"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btr670"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e6b454b3d7c06b6ce6b523ee6a87fd2a7a8b60383493b07d82c23d641a7b2c4" => :sierra
    sha256 "19991ae34f6ac95ff8eebe922366402c837a3677c9920c185aecf3b33b1ffabf" => :el_capitan
    sha256 "b4f93ca403b077789b1d40ac4398f0ebc9cdfea3c654919bec0802c42361cb59" => :yosemite
    sha256 "cde3295808a1df20f62f503e42c457a9ae7429205cba6264f6f690a6fd24af99" => :x86_64_linux
  end

  def install
    cd "src" do
      system "make"
      bin.install "freec"
    end
    pkgshare.install "scripts", "data"
  end

  test do
    assert_match "FREEC v#{version}", shell_output("#{bin}/freec 2>&1")
  end
end
