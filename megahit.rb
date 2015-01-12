class Megahit < Formula
  homepage "https://github.com/voutcn/megahit"
  #doi "arXiv:1409.7208"
  #tag "bioinformatics"

  url "https://github.com/voutcn/megahit/archive/v0.1.3.tar.gz"
  sha1 "8a5d48f1a38ce352f3440b7795538679dafb0602"

  head "https://github.com/voutcn/megahit.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "98659f38c059b1196c92263440b25ee3e2b7f301" => :yosemite
    sha1 "045e00905aff83cabb3794e2f96940439a7c5caf" => :mavericks
    sha1 "d728fe0a0f9a1041822befe6875b7e3e4591bb7b" => :mountain_lion
  end

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
