class Minced < Formula
  desc "Mining CRISPRs in Environmental Datasets"
  homepage "https://github.com/ctSkennerton/minced"
  # tag "bioinformatics"

  url "https://github.com/ctSkennerton/minced/releases/download/0.1.6/minced.jar"
  sha256 "acccd14078a29fbd79d7848e080e28c4a1f1f8f799376b6de41f937bb2984f43"

  # head "https://github.com/ctSkennerton/minced.git"

  depends_on :java

  def install
    name = "minced"
    (share/name).install "#{name}.jar"
    bin.write_jar_script share/"#{name}/#{name}.jar", name
  end

  test do
    (testpath/"test.fa").write <<-EOS.undent
    >CRISPR Escherichia coli UTI89 886538..887045
    GTTCACTGCCGTACAGGCAGCTTAGAAATGACGCCATATGCAGATCATTGAGGCGAAACC
    GTTCACTGCCGTACAGGCAGCTTAGAAAACGTTCGCACCGGTCAGGGTACTGCGCAGCGT
    GTTCACTGCCGTACAGGCAGCTTAGAAAGAAACCAGAGCGCCCGCATAAAACAGGCACAA
    GTTCACTGCCGTACAGGCAGCTTAGAAAGCCAGCATAAAACCGCCTTTGATATTTTATTG
    GTTCACTGCCGTACAGGCAGCTTAGAAATCAGCCGGAGGCTCTCAATTTCAGCCGCGCGG
    GTTCACTGCCGTACAGGCAGCTTAGAAAAGCACGGCTGCGGGGAATGGCTCAATCTCTGC
    GTTCACTGCCGTACAGGCAGCTTAGAAATGATGGCGCAGCAGTCCTCCCTCCTGCCGCCA
    GTTCACTGCCGTACAGGCAGCTTAGAAACTGAACGTTGAAGAGTGCGACCGTCTCTCCTT
    GTTCACTGCCGTACAGGCAGTATTCACA
    EOS
    assert_match "1\t507\t9", shell_output("#{bin}/minced -gff #{testpath}/test.fa")
  end
end
