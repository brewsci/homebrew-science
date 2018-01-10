class Minced < Formula
  desc "Mining CRISPRs in Environmental Datasets"
  homepage "https://github.com/ctSkennerton/minced"
  url "https://github.com/ctSkennerton/minced/archive/0.2.0.tar.gz"
  sha256 "e1ca61e0307e6a2a2480bc0a1291a2c677110f34c3247d4773fdba7e95a6b573"
  head "https://github.com/ctSkennerton/minced.git"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "a216985fb9de6c65592a71c336ce839bcf6369a9be4555a0144e1ea10eaa78b5" => :el_capitan
    sha256 "b2a6011525aeaeec87cb6585076aa6eb73b082af726560204be829381c5bed90" => :yosemite
    sha256 "0fd88dba11618543b5862298780961df12d0e9cb6f353ffdc173004e8d403839" => :mavericks
    sha256 "47c01ab05039209cc26031aaafe3a16e7a5685714de26ec789fb0e7c6654e514" => :x86_64_linux
  end

  depends_on :java => "1.8"

  def install
    system "make"
    libexec.install "minced.jar"
    bin.write_jar_script libexec/"minced.jar", "minced"
    pkgshare.install Dir["t/*"]
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
