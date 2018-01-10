class SeqGen < Formula
  desc "Simulator of DNA and amino acid sequence evolution"
  homepage "http://tree.bio.ed.ac.uk/software/seqgen/"
  url "https://github.com/rambaut/Seq-Gen/archive/1.3.4.tar.gz"
  sha256 "092ec2255ce656a02b2c3012c32443c7d8e38c692f165fb155b304ca030cbb59"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9ff4a5b0ee94ab990bd9cbeafe60ab652ed5197bf7111f0cfd8ec76426e89c3" => :high_sierra
    sha256 "772c48c053f90b6826910ee9b02d742397b5348eba99eb7fa75f1e1464ddab0a" => :sierra
    sha256 "f0bab4aea0dfe1f025460c43d7c1d3e39c7ddea35bd06cc4b1c0aa56769b6fcc" => :el_capitan
    sha256 "ab0fa30e722f79c3dc822c182bacfe9346abf005e373d32877ba3415a25ae422" => :x86_64_linux
  end

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
