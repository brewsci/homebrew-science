class Aragorn < Formula
  homepage "http://mbio-serv2.mbioekol.lu.se/ARAGORN/"
  # doi "10.1093/nar/gkh152"

  url "http://mbio-serv2.mbioekol.lu.se/ARAGORN/Downloads/aragorn1.2.36.tgz"
  sha256 "ab06032589e45aa002f8616333568e9ab11034b3a675f922421e5f1c3e95e7b5"

  bottle do
    cellar :any
    sha256 "834a9a7024698f373368311b72bdd2f8f01d02eac5d21069db90dbc30c7e4472" => :yosemite
    sha256 "68f43cb5d323ea461fde1c9ef71da6138fe124f080f705979394c86e8cad8f5b" => :mavericks
    sha256 "298b20562fee2a1b925aa0cd569c1c06d3cd1124faf0059a5c94e269db992189" => :mountain_lion
  end

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
