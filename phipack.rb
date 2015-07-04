class Phipack < Formula
  desc "A quick and robust genomic recombination test"
  homepage "http://www.maths.otago.ac.nz/~dbryant/software.html"
  # doi "10.1534/genetics.105.048975"
  # tag "bioinformatics"

  url "http://www.maths.otago.ac.nz/~dbryant/software/PhiPack.tar"
  version "2013-03-05"
  sha256 "bee88a90c081caac427f7bc206a59ae9a51b9d4affdb3a53750d7f9da109e193"

  def install
    system "make", "-C", "src"
    bin.install "Phi", "Profile", "ppma_2_bmp"
    doc.install "README"
    (share/"phipack").install "ATP6.phy", Dir["*.fast*"]
  end

  test do
    dir = share/"phipack"
    system "#{bin}/Phi", "-f", "#{dir}/h_pylori.fasta", "-s", "#{dir}/ATP6.phy"
    assert File.exist?("Phi.inf.list")
    assert File.exist?("Phi.inf.sites")
    assert File.read("Phi.log").include?("Found 53 informative sites")
  end
end
