require "formula"

class Giira < Formula
  homepage "https://sourceforge.net/projects/giira/"
  url "https://downloads.sourceforge.net/project/giira/GIIRA.zip"
  sha1 "f16e779316ec446ab11f76a44cdf2fd756cdf094"
  version "2014-02-10"

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
