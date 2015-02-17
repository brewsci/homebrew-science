class Grabix < Formula
  homepage "https://github.com/arq5x/grabix"
  # tag "bioinformatics"
  url "https://github.com/arq5x/grabix/archive/1.4.tar.gz"
  sha1 "687c6874741127c012e84cad4d85a5116afc1034"
  head "https://github.com/arq5x/grabix.git"

  def install
    system "make"
    bin.install "grabix"
    doc.install "README.md"
    share.install "simrep.chr1.bed"
  end

  test do
    assert_equal `#{bin}/grabix check #{share}/simrep.chr1.bed`.chomp, "no"
  end
end
