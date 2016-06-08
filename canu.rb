class Canu < Formula
  desc "Single molecule sequence assembler"
  homepage "http://canu.readthedocs.org/en/latest/"
  url "https://github.com/marbl/canu/archive/v1.3.tar.gz"
  sha256 "7a85e4999baf75553f738b9fb263c17772d7630368d3b7321b8d90f3dc584457"
  head "https://github.com/marbl/canu.git"
  # doi "10.1038/nbt.3238"
  # tag "bioinformatics"

  bottle do
    sha256 "f37d258084205d89ec0aecaa3c04500a394d10b6f357f790ca75bbc40b6f2af3" => :el_capitan
    sha256 "564612c7a5b5de07e7dbd46586df47380f0149c78a21c25abcd215a41727bd98" => :yosemite
    sha256 "496e8b42bdcca4612cede42d3676345a14bfb234937cfb314d4d65a9cea7ae26" => :mavericks
    sha256 "cf424d48cdd5a6a427b77de3dc4ea55fa6a9b299e6c2d0e84baf8e231ee3de94" => :x86_64_linux
  end

  # Fix fatal error: 'omp.h' file not found
  needs :openmp

  def install
    system "make", "-C", "src"
    arch = Pathname.new(Dir["*/bin"][0]).dirname
    rm_r arch/"obj"
    prefix.install arch
    bin.install_symlink prefix/arch/"bin/canu"
    doc.install Dir["README.*"]
  end

  test do
    system "#{bin}/canu", "--version"
  end
end
