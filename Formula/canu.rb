class Canu < Formula
  desc "Single molecule sequence assembler"
  homepage "https://canu.readthedocs.org/en/latest/"
  url "https://github.com/marbl/canu/archive/v1.6.tar.gz"
  sha256 "470e0ac761d69d1fecab85da810a6474b1e2387d7124290a0e4124d660766498"
  head "https://github.com/marbl/canu.git"
  # doi "10.1038/nbt.3238"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "d39fee4aec9f92353716ad98e9752495ad23fd51093fe5561d4e51702c3499e2" => :sierra
    sha256 "1563572b093f51acef19013c274e6a5cd0e3a6cd86f65b8d67814bd45a2a6a19" => :el_capitan
    sha256 "8d53e97c1b492a5b05d793dbbb1d559119e206c21df75df19414f128d00ff335" => :yosemite
    sha256 "2381fb88c22582ba797cb2d5cd11cd222fd56656e770b014f9ac0e20c2a3ea56" => :x86_64_linux
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
