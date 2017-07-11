class Freebayes < Formula
  desc "Bayesian variant discovery and genotyping"
  homepage "https://github.com/ekg/freebayes"
  # doi "arXiv:1207.3907v2"
  # tag "bioinformatics"

  url "https://github.com/ekg/freebayes.git",
      :tag => "v1.1.0",
      :revision => "39e5e4bcb801556141f2da36aba1df5c5c60701f"
  revision 1

  head "https://github.com/ekg/freebayes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "08b1ecf44cd48df30e4153c316d5243a74ab031437e9b1c345d4a28ffa113924" => :sierra
    sha256 "5e29543bbfc45f511940b79caa2cd9b8eb87b8beaf0e4d73659f25015c41b582" => :el_capitan
    sha256 "89bb6104d99f6923b621f43a75347b244c984097d2a87673405beb26f93e3e94" => :yosemite
    sha256 "59cd11da5935455a842a0554a25d5b60765cc4cb1aa885be7d8f4adf97a37ea4" => :x86_64_linux
  end

  depends_on "cmake" => :build

  depends_on "parallel"
  depends_on "vcflib"
  depends_on "zlib" unless OS.mac?

  def install
    # make -j N results in: make: *** [all] Error 2
    # Reported 16 Jan 2017 https://github.com/ekg/freebayes/issues/356
    ENV.deparallelize

    # Works around ld: internal error: atom not found in symbolIndex
    # Reported 21 Jul 2014 https://github.com/ekg/freebayes/issues/83
    inreplace "vcflib/smithwaterman/Makefile", "-Wl,-s", "" if OS.mac?

    # Fixes bug ../vcflib/scripts/vcffirstheader: file not found
    # Reported 1 Apr 2017 https://github.com/ekg/freebayes/issues/376
    inreplace "scripts/freebayes-parallel" do |s|
      s.gsub! "../vcflib/scripts/vcffirstheader", "vcffirstheader"
      s.gsub! "../vcflib/bin/vcfstreamsort", "vcfstreamsort"
    end

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
    assert_match "polymorphism", shell_output("#{bin}/freebayes --help 2>&1")
    assert_match "chunks", shell_output("#{bin}/freebayes-parallel 2>&1")
  end
end
