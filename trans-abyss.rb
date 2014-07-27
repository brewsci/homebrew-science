require 'formula'

class TransAbyss < Formula
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/trans-abyss"
  #doi "10.1038/nmeth.1517"
  head "https://github.com/bcgsc/transabyss.git"

  url "https://github.com/bcgsc/transabyss/archive/1.5.1.tar.gz"
  sha1 "6bbe6123bd0142b6b10190ff95752641090350b0"

  depends_on "abyss"
  depends_on "blat"
  depends_on "bowtie2"
  depends_on "gmap-gsnap"
  depends_on "igraph"
  depends_on "picard-tools"
  depends_on "samtools"

  depends_on "pysam" => :python
  depends_on LanguageModuleDependency.new :python, "biopython", "Bio"
  depends_on LanguageModuleDependency.new :python, "python-igraph", "igraph"

  def install
    prefix.install Dir["*"]
    bin.install_symlink "../transabyss",
      "../transabyss-analyze",
      "../transabyss-merge"
  end

  test do
    system "transabyss --help"
    system "transabyss-analyze --help"
    system "transabyss-merge --help"
  end
end
