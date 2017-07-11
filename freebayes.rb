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
    sha256 "559edc61905e4893694929bb15b066f3b8f85aa4d08d2c2d507a99431b69a93d" => :sierra
    sha256 "4b8dfacfad2a7435eaa7951bb70b3716de705ebf2e6ebdacb8ea60e690b9e700" => :el_capitan
    sha256 "5c83b009e6866a1832a0391bfb9e8ad1fe1fe6687f7987aed6dbf322ea7bdd57" => :yosemite
    sha256 "71394a22c6b01663447b6f0ae22a33432dc878dc70dfab622044a60977cd7a6b" => :x86_64_linux
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
