class Readsim < Formula
  homepage "https://sourceforge.net/p/readsim/wiki/Home/"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/readsim/readsim-1.6.tar.gz"
  sha256 "44ff24eb2e3127bfa717ba65857ecd5380303b6c2f4067d3b4b30a41eb790bb3"

  bottle do
    cellar :any
    sha256 "0b3103ce65332c1fe781d6a52a3ac46d89c99d0d87a8e12f872c6d50ee597c9e" => :yosemite
    sha256 "c663b3d74d092eb246a1e6d23bc1b466fc10b73bd89c621510c5155ff2095516" => :mavericks
    sha256 "3a15b549621a44b9cfbad453757686e1251f0092a5e15cd3cfa934cb59b555be" => :mountain_lion
    sha256 "f569a6d762071647ad5202008271e489404448ee98719877855a2aa93393aabe" => :x86_64_linux
  end

  def install
    prefix.install Dir["*"]
    bin.install_symlink "../src/readsim.py", "../src/dnasim.py"
  end

  test do
    system "#{bin}/readsim.py"
  end
end
