require "formula"

class Giira < Formula
  homepage "https://sourceforge.net/projects/giira/"
  url "https://downloads.sourceforge.net/project/giira/GIIRA_01_1.zip"
  sha1 "cde28ddbf67035e7a313f1a2395e963dcaaf3343"
  version "20140221" # based on Debian source version

  depends_on "glpk"
  depends_on :python
  depends_on "tophat"

  def install
    libexec.install "GIIRA.jar", "scripts"
    bin.write_jar_script libexec/"GIIRA.jar", "GIIRA"
  end

  test do
    (testpath/"test.fasta").write <<-EOS.undent
    >gi|330443520|ref|NC_001136.10| Saccharomyces cerevisiae
    ACACCACACCCACACCACACCCACACACACCACACCCACACACCACACCCACACCCACACACCCACACCC
    EOS
    (testpath/"test.fastq").write <<-EOS.undent
    @scer_part1_c15.000000000 contig=lcl|NC_001136.10_cdsid_NP_010096.1
    CAATTTTTCGCATTCGCCATGGACTTCCTTTTCACCCCTGCTTGGTTCAA
    EOS

    output = `#{bin}/GIIRA -iG test.fasta -iR test.fastq -opti glpk`
    output.include? ("Gene identification finished")
  end
end
