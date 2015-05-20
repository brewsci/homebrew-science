class TransAbyss < Formula
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/trans-abyss"
  # doi "10.1038/nmeth.1517"
  # tag "bioinformatics"

  url "https://github.com/bcgsc/transabyss/archive/1.5.2.tar.gz"
  sha256 "8b5b0a333c1407a73170521a439e5f381b07c9df8f660c5f5f52000c04aa03c2"

  head "https://github.com/bcgsc/transabyss.git"

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
    system "#{bin}/transabyss", "--help"
    system "#{bin}/transabyss-analyze", "--help"
    system "#{bin}/transabyss-merge", "--help"
  end
end
