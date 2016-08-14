class Freebayes < Formula
  desc "Bayesian variant discovery and genotyping"
  homepage "https://github.com/ekg/freebayes"
  url "https://github.com/ekg/freebayes.git",
    :tag => "v1.0.2",
    :revision => "0cb269728b2db6307053cafe6f913a8b6fa1331e"
  revision 1
  head "https://github.com/ekg/freebayes.git"
  # doi "arXiv:1207.3907v2"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "299858bffe93d8b1952d20b597e91a2d22a78d7001e3855272b20db018e2b715" => :el_capitan
    sha256 "303723bb1b6fba6a009198ffa956d6bd7b6d4a2acaddc6933714554a9dc6bfb4" => :yosemite
    sha256 "23201ee36b507225d714a70f1bf9b2fa9a9a92a315cb23b61ebc3f289f012bc1" => :mavericks
    sha256 "ce016dab3a80a5d96aba85c3267ba3954c2ff56b57a002715a93825b26f39aa6" => :x86_64_linux
  end

  depends_on "cmake" => :build

  depends_on "parallel" => :recommended
  depends_on "vcflib" => :recommended

  def install
    # Build fix: https://github.com/chapmanb/homebrew-cbl/issues/14
    inreplace "vcflib/smithwaterman/Makefile", "-Wl,-s", "" if OS.mac?

    # Use brewed python
    inreplace "scripts/fasta_generate_regions.py", "#!/usr/bin/python", "#!/usr/bin/env python"

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
