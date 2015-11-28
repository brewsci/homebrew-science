class Minced < Formula
  desc "Mining CRISPRs in Environmental Datasets"
  homepage "https://github.com/ctSkennerton/minced"
  bottle do
    cellar :any
    sha256 "52af6d39cf5c38d4be24c04a1febec2dea60e2725eb43b4594c8de816984058b" => :yosemite
    sha256 "e702a38fc2a6c461369d297e66f1baa74a22e2ce2e37cedeeb48f49de9c7ea42" => :mavericks
    sha256 "3fa76116539321ca84774df87972b08c54a810a59d86d5a9a5dba56abc8f0464" => :mountain_lion
  end

  # tag "bioinformatics"

  url "https://github.com/ctSkennerton/minced/releases/download/0.2.0/minced.jar"
  sha256 "8c908302b829b7e1b787742e1ef7a602f5d15ac40b4fc7a24208368b0c147038"

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
