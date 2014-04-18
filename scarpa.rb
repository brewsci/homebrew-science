require "formula"

class Scarpa < Formula
  homepage "http://compbio.cs.toronto.edu/hapsembler/scarpa.html"
  #doi "10.1093/bioinformatics/bts716"
  url "http://compbio.cs.toronto.edu/hapsembler/scarpa-0.241.tar.gz"
  sha1 "f238d8ea418951754b0f37aad7f09c9cf00fc909"

  depends_on "lp_solve"

  def install
    rm Dir["liblpsolve55.*"]
    inreplace "Makefile", "liblpsolve55.a", "-llpsolve55"
    system "make"
    bin.install "bin/scarpa"
    doc.install "SCARPA.README"
  end

  test do
    system "#{bin}/scarpa --version"
  end
end
