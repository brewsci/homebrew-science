class Aragorn < Formula
  desc "tRNA and tmRNA detection"
  homepage "http://mbio-serv2.mbioekol.lu.se/ARAGORN/"
  # doi "10.1093/nar/gkh152"
  # tag "bioinformatics

  url "http://mbio-serv2.mbioekol.lu.se/ARAGORN/Downloads/aragorn1.2.38.tgz"
  sha256 "4b84e3397755fb22cc931c0e7b9d50eaba2a680df854d7a35db46a13cecb2126"

  bottle do
    cellar :any_skip_relocation
    sha256 "45b1f0c63b4ffc0c564ece26c839259bf723b69c7dbe621ce2d4fe1131a1666c" => :high_sierra
    sha256 "64bf898f9262a25fe4a7b28e5e542b1a2927ec3a884851d2623b61742eaf4a16" => :sierra
    sha256 "d59bd3eaf61234b4b584a6f53754f8e7f2f704c6a9c6218dcd23034b34105ef6" => :el_capitan
    sha256 "8db65b56fa5f2a708ef7ad585c396e36a892d4bb9cdd3ee56a4fdde188c14415" => :x86_64_linux
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
    assert_match "tRNA-Ala", shell_output("#{bin}/aragorn -w #{testpath}/test.fa")
  end
end
