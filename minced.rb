class Minced < Formula
  desc "Mining CRISPRs in Environmental Datasets"
  homepage "https://github.com/ctSkennerton/minced"
  bottle do
    cellar :any_skip_relocation
    sha256 "a216985fb9de6c65592a71c336ce839bcf6369a9be4555a0144e1ea10eaa78b5" => :el_capitan
    sha256 "b2a6011525aeaeec87cb6585076aa6eb73b082af726560204be829381c5bed90" => :yosemite
    sha256 "0fd88dba11618543b5862298780961df12d0e9cb6f353ffdc173004e8d403839" => :mavericks
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
