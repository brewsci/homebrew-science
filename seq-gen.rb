class SeqGen < Formula
  desc "Simulator of DNA and amino acid sequence evolution"
  homepage "http://tree.bio.ed.ac.uk/software/seqgen/"
  url "https://github.com/rambaut/Seq-Gen/archive/1.3.4.tar.gz"
  sha256 "092ec2255ce656a02b2c3012c32443c7d8e38c692f165fb155b304ca030cbb59"

  def install
    cd "source" do
      system "make"
      bin.install "seq-gen"
    end
    pkgshare.install ["examples", "documentation"]
  end

  def caveats
    "The manual and examples are installed to #{HOMEBREW_PREFIX}/share/seq-gen."
  end

  test do
    system "#{bin}/seq-gen", "-h"
  end
end
