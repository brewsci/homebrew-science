class Aragorn < Formula
  homepage "http://mbio-serv2.mbioekol.lu.se/ARAGORN/"
  # doi "10.1093/nar/gkh152"

  url "http://mbio-serv2.mbioekol.lu.se/ARAGORN/Downloads/aragorn1.2.36.tgz"
  sha256 "ab06032589e45aa002f8616333568e9ab11034b3a675f922421e5f1c3e95e7b5"

  def install
    mv "aragorn#{version}.c", "aragorn.c"
    system "make", "aragorn"
    bin.install "aragorn"
    man1.install "aragorn.1"
  end

  test do
    (testpath/"test.fa").write <<-EOS.undent
      >sequence
      GGGGCTATAGCTCAGTTGGGAGAGCGCTGCAATCGCACTG
      CAGAGGTCGTCAGTTCGAACCTGACTAGCTCCACCA
    EOS
    assert_match "tRNA-Ala", shell_output("aragorn -w #{testpath}/test.fa")
  end
end
