class SeqGen < Formula
  homepage "http://tree.bio.ed.ac.uk/software/seqgen/"
  url "http://tree.bio.ed.ac.uk/download.php?id=85"
  sha256 "ad00e69b2f6915b9b873d71cb30c37e1a2d61e7831e8e214b3b2ddcdb3e9c45b"
  version "1.3.3"

  def install
    cd "source" do
      system "make"
      bin.install "seq-gen"
    end
    (share/"seq-gen").install ["examples", "documentation"]
  end

  def caveats
    "The manual and examples are installed to #{HOMEBREW_PREFIX}/share/seq-gen."
  end

  test do
    system "#{bin}/seq-gen", "-h"
  end
end
