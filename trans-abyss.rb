class TransAbyss < Formula
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/trans-abyss"
  # doi "10.1038/nmeth.1517"
  # tag "bioinformatics"

  url "https://github.com/bcgsc/transabyss/archive/1.5.3.tar.gz"
  sha256 "6b2471b05443962a5e99ba53427cc622e42b1e1e94572f4a58f54673df4c82fd"

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
