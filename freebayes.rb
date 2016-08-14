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
