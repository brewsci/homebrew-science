class Megahit < Formula
  homepage "https://github.com/voutcn/megahit"
  #doi "arXiv:1409.7208"
  #tag "bioinformatics"

  url "https://github.com/voutcn/megahit/archive/v0.2.0-a.tar.gz"
  sha256 "5b30a163027b248bf2d96c766c3bcf1f4fe50466e368a3844b3c4e0a2491d8c4"

  head "https://github.com/voutcn/megahit.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "98659f38c059b1196c92263440b25ee3e2b7f301" => :yosemite
    sha1 "045e00905aff83cabb3794e2f96940439a7c5caf" => :mavericks
    sha1 "d728fe0a0f9a1041822befe6875b7e3e4591bb7b" => :mountain_lion
  end

  fails_with :llvm do
    build 2336
    cause <<-EOS.undent
    llvm-g++ does not support -mpopcnt, -std=c++0x
    options
    EOS
  end

  # Fix error: 'omp.h' file not found
  needs :openmp

  def install
    system "make"
    bin.install ["megahit",
                 "megahit_assemble",
                 "megahit_iter_k124",
                 "megahit_iter_k61",
                 "megahit_iter_k92",
                 "sdbg_builder_cpu"]

    doc.install "ChangeLog.md", "README.md"
  end

  test do
    system "#{bin}/megahit --help 2>&1 |grep megahit"
  end
end
