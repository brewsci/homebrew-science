class Canu < Formula
  desc "Single molecule sequence assembler"
  homepage "http://canu.readthedocs.org/en/latest/"
  url "https://github.com/marbl/canu/archive/v1.2.tar.gz"
  sha256 "d3ad2afd9ca0967cbfa401342ff118b1eb9ed86237507c7d74a4543d1e876abc"
  head "https://github.com/marbl/canu.git"
  # doi "10.1038/nbt.3238"
  # tag "bioinformatics"

  bottle do
    sha256 "f8ce014f75c7e837c515d85bd01a0a85d9dad36d07b391fc91fb958bd6df7642" => :el_capitan
    sha256 "22b0b00a9c27f622a65f4e870489b6ee2982f514d9d74a775b06c199d95f35da" => :yosemite
    sha256 "0c15b18bc91d6836ed41ebac8d272a8bce1e656193bb63bba34d4c3f232f8a58" => :mavericks
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
