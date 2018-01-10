class Phipack < Formula
  desc "Quick and robust genomic recombination test"
  homepage "https://www.maths.otago.ac.nz/~dbryant/software.html"
  # doi "10.1534/genetics.105.048975"
  # tag "bioinformatics"

  url "https://www.maths.otago.ac.nz/~dbryant/software/PhiPack.tar"
  version "2013-03-05"
  sha256 "bee88a90c081caac427f7bc206a59ae9a51b9d4affdb3a53750d7f9da109e193"

  bottle do
    cellar :any
    sha256 "1fabe869b7a87d8fec85ca7cf7ee1899d12a38994a6046f203f83026733c91a3" => :yosemite
    sha256 "c0af865b47d6146ffa65ae63049933c0cebe523e8ea51edd3b43e85af63c43c8" => :mavericks
    sha256 "8c0f3cd292ba7964acbcd388ad04dccee785c69288c9d78169e9bf7fba9e5ef6" => :mountain_lion
    sha256 "d14f04741addecb41c8c212f67f82915a78993335adf61fef8736c23ad140ed3" => :x86_64_linux
  end

  def install
    system "make", "-C", "src"
    bin.install "Phi", "Profile", "ppma_2_bmp"
    doc.install "README"
    pkgshare.install "ATP6.phy", Dir["*.fast*"]
  end

  test do
    system "#{bin}/Phi", "-f", "#{pkgshare}/h_pylori.fasta", "-s", "#{pkgshare}/ATP6.phy"
    assert File.exist?("Phi.inf.list")
    assert File.exist?("Phi.inf.sites")
    assert File.read("Phi.log").include?("Found 53 informative sites")
  end
end
