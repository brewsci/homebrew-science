class Tetgen < Formula
  homepage "http://wias-berlin.de/software/tetgen/"
  url "http://www.tetgen.org/1.5/src/tetgen1.5.0.tar.gz"
  sha256 "4d114861d5ef2063afd06ef38885ec46822e90e7b4ea38c864f76493451f9cf3"

  def install
    system "make"
    system "make", "tetlib"
    bin.install "tetgen"
    lib.install "libtet.a"
    include.install "tetgen.h"
    doc.install %w[README LICENSE example.poly]
  end

  test do
    system "#{bin}/tetgen", "#{doc}/example.poly"
  end

  def caveats; <<-EOS.undent
    Please register as a TetGen user at
    http://wias-berlin.de/software/tetgen/download2.jsp.
    EOS
  end
end
