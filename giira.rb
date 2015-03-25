class Giira < Formula
  homepage "https://sourceforge.net/projects/giira/"
  url "https://downloads.sourceforge.net/project/giira/GIIRA_01_3.zip"
  sha256 "3caecf4297bf219b006094d7a2a1510f07c2c32223add482a405089699b64bb2"

  depends_on "glpk"
  depends_on "tophat"

  def install
    mv "GIIRA_01_3.jar", "GIIRA.jar"
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
    assert `#{bin}/GIIRA -iG test.fasta -iR test.fastq -opti glpk`.include?("finished")
  end
end
