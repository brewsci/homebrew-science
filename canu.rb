class Canu < Formula
  desc "Single molecule sequence assembler"
  homepage "http://canu.readthedocs.org/en/latest/"
  url "https://github.com/marbl/canu/archive/v1.2.tar.gz"
  sha256 "d3ad2afd9ca0967cbfa401342ff118b1eb9ed86237507c7d74a4543d1e876abc"
  head "https://github.com/marbl/canu.git"
  # doi "10.1038/nbt.3238"
  # tag "bioinformatics"

  bottle do
    sha256 "d08ddccdf35db8f56ca3fe4ffab9ac2399eccc8a69d132af5da08f051fd0444f" => :el_capitan
    sha256 "e10a7e2c267357796ef323d658d552137a0696eca387f0cff440f27961e8e921" => :yosemite
    sha256 "d6457d33343be2b51eba8a42ba984ed7b4fc4b9b6f4995a209cc0f76b790fd18" => :mavericks
    sha256 "1cd6d0cebffef5895dc6e532a837f8f10e126920f298bee8cde49dd0c2f41305" => :x86_64_linux
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
