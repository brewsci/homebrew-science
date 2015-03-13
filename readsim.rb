class Readsim < Formula
  homepage "https://sourceforge.net/p/readsim/wiki/Home/"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/readsim/readsim-1.6.tar.gz"
  sha256 "44ff24eb2e3127bfa717ba65857ecd5380303b6c2f4067d3b4b30a41eb790bb3"

  def install
    prefix.install Dir["*"]
    bin.install_symlink "../src/readsim.py", "../src/dnasim.py"
  end

  test do
    system "#{bin}/readsim.py"
  end
end
