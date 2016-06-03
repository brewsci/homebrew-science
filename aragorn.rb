class Aragorn < Formula
  desc "tRNA and tmRNA detection"
  homepage "http://mbio-serv2.mbioekol.lu.se/ARAGORN/"
  # doi "10.1093/nar/gkh152"
  # tag "bioinformatics

  url "http://mbio-serv2.mbioekol.lu.se/ARAGORN/Downloads/aragorn1.2.36.tgz"
  sha256 "ab06032589e45aa002f8616333568e9ab11034b3a675f922421e5f1c3e95e7b5"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2f7ed8dc01aae4b9137f5825aace3aa0ee068b0fbec995703f3ff1cd16ab6402" => :sierra
    sha256 "88d79d7d6175a458e2452da9f4871d426671a5b1934c14ee38f664aa63659dab" => :el_capitan
    sha256 "5352a50548ef3e7a9818356f74f208d36acc711f106be2c6a203050e793e414f" => :yosemite
    sha256 "8e9939797bdb6d1846b0ed296a377b047d051e1699cc58f1bdfc50a176789e33" => :mavericks
    sha256 "e87c85dddd796c958d1f3c0d9dbe477b601608a2c4a709025257ebb31a6355e2" => :x86_64_linux
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
