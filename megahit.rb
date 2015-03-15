class Megahit < Formula
  homepage "https://github.com/voutcn/megahit"
  # doi "arXiv:1409.7208"
  # tag "bioinformatics"

  url "https://github.com/voutcn/megahit/archive/v0.2.0-a.tar.gz"
  version "0.2.0-a"
  sha256 "5b30a163027b248bf2d96c766c3bcf1f4fe50466e368a3844b3c4e0a2491d8c4"

  head "https://github.com/voutcn/megahit.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "6d171e0c21bcc67ef9e4bbd538a718c362d43fc513d655d3241df44a3290b8dc" => :yosemite
    sha256 "0706495a817b98545f158039186c43949801c76b10a5f9cb73da0602fac25f22" => :mavericks
    sha256 "393cae05797379670d7aa726e652801552d0ac775406547936a67869b756eedf" => :mountain_lion
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
