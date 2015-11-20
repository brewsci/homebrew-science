require "formula"

class Scarpa < Formula
  homepage "http://compbio.cs.toronto.edu/hapsembler/scarpa.html"
  #doi "10.1093/bioinformatics/bts716"
  #tag "bioinformatics"

  url "http://compbio.cs.toronto.edu/hapsembler/scarpa-0.241.tar.gz"
  sha1 "f238d8ea418951754b0f37aad7f09c9cf00fc909"

  bottle do
    cellar :any
    sha256 "c8eca0370427c99c07735f9bf4d2db7149aa17cf221ee90f66b4fcc9c5f1a3f3" => :yosemite
    sha256 "8b1d2ffaa4981728042baac900544b43f2a384520d7a508da9c8242a21fa2bd9" => :mavericks
    sha256 "aa03bd7b53f6101dedb8a79bc053a8267e9bf49967d537ae9bce50ecb1323134" => :mountain_lion
  end

  depends_on "lp_solve"

  def install
    rm Dir["liblpsolve55.*"]
    inreplace "Makefile", "liblpsolve55.a", "-llpsolve55"
    system "make"
    bin.install "bin/scarpa"
    doc.install "SCARPA.README"
  end

  test do
    system "#{bin}/scarpa", "--version"
  end
end
