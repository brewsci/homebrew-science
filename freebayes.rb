class Freebayes < Formula
  desc "Bayesian variant discovery and genotyping"
  homepage "https://github.com/ekg/freebayes"
  url "https://github.com/ekg/freebayes.git",
      :tag => "v1.1.0",
      :revision => "39e5e4bcb801556141f2da36aba1df5c5c60701f"
  head "https://github.com/ekg/freebayes.git"
  # doi "arXiv:1207.3907v2"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "08b1ecf44cd48df30e4153c316d5243a74ab031437e9b1c345d4a28ffa113924" => :sierra
    sha256 "5e29543bbfc45f511940b79caa2cd9b8eb87b8beaf0e4d73659f25015c41b582" => :el_capitan
    sha256 "89bb6104d99f6923b621f43a75347b244c984097d2a87673405beb26f93e3e94" => :yosemite
    sha256 "59cd11da5935455a842a0554a25d5b60765cc4cb1aa885be7d8f4adf97a37ea4" => :x86_64_linux
  end

  depends_on "cmake" => :build

  depends_on "parallel" => :recommended
  depends_on "vcflib" => :recommended

  def install
    ENV.deparallelize

    # Build fix: https://github.com/chapmanb/homebrew-cbl/issues/14
    inreplace "vcflib/smithwaterman/Makefile", "-Wl,-s", "" if OS.mac?

    system "make"

    bin.install "bin/freebayes"
    bin.install "bin/bamleftalign"
    bin.install "scripts/freebayes-parallel"
    bin.install "scripts/coverage_to_regions.py"
    bin.install "scripts/generate_freebayes_region_scripts.sh"
    bin.install "scripts/fasta_generate_regions.py"
    doc.install "README.md"
  end

  test do
    system "#{bin}/freebayes", "--version"
    system "#{bin}/freebayes-parallel"
  end
end
