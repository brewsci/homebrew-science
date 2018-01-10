class Phlawd < Formula
  desc "Phylogenetic dataset construction"
  homepage "https://www.phlawd.net/"
  url "https://github.com/jonchang/phlawd/archive/3.4b.tar.gz"
  version "3.4b"
  sha256 "a0fea43866e425f7fed5f74bcb8c391484a10b486f3f03d5b7bbc4df84dd84b8"
  head "https://github.com/jonchang/phlawd.git"
  # doi "10.1186/1471-2148-9-37"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "b0420865ca473c2220846163461df00977207f3e71fc1fb37880f1d2b6db9621" => :sierra
    sha256 "33de754f947b42667e1d5f6e733e26447764d2cd1dc716b94f39de8e0353f1ba" => :el_capitan
    sha256 "1217f95cda2926c4dba3dff7ce52a71f67190eba4421ebd52a55743c2fb8ce5a" => :yosemite
    sha256 "effb2ad60e5b380ea05d8330ea4d3c6f11069964f07d28e6cdc2b33e40194332" => :x86_64_linux
  end

  needs :openmp

  depends_on "gcc" if OS.mac?
  depends_on "wget"
  depends_on "mafft"
  depends_on "muscle"
  depends_on "quicktree"
  depends_on "sqlite"

  def install
    cd "src" do
      system "./configure"
      system "make"
      bin.install "PHLAWD"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/PHLAWD")
  end
end
