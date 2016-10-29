class TransAbyss < Formula
  desc "Assemble RNA-Seq data using ABySS"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/trans-abyss"
  # doi "10.1038/nmeth.1517"
  # tag "bioinformatics"

  url "https://github.com/bcgsc/transabyss/archive/1.5.3.tar.gz"
  sha256 "0661f70d9d971edb3b225906082860c5531adcc4ecb4cceb24365b96c529af96"

  bottle :unneeded

  head "https://github.com/bcgsc/transabyss.git"

  depends_on "abyss"
  depends_on "blat"
  depends_on "bowtie2"
  depends_on "gmap-gsnap"
  depends_on "igraph"
  depends_on "picard-tools"
  depends_on "samtools"

  depends_on "pysam" => :python
  depends_on LanguageModuleRequirement.new :python, "biopython", "Bio"
  depends_on LanguageModuleRequirement.new :python, "python-igraph", "igraph"

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
