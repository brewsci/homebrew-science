class Megahit < Formula
  homepage "https://github.com/voutcn/megahit"
  #doi "arXiv:1409.7208"
  #tag "bioinformatics"

  url "https://github.com/voutcn/megahit/archive/v0.1.3.tar.gz"
  sha1 "8a5d48f1a38ce352f3440b7795538679dafb0602"

  head "https://github.com/voutcn/megahit.git"

  # Fix error: 'omp.h' file not found
  needs :openmp

  def install
    system "make"
    bin.install "megahit"
    doc.install "ChangeLog.md", "README.md"
  end

  test do
    system "#{bin}/megahit --help 2>&1 |grep megahit"
  end
end
