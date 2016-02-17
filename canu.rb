class Canu < Formula
  desc "Single molecule sequence assembler"
  homepage "http://canu.readthedocs.org/en/latest/"
  url "https://github.com/marbl/canu/archive/v1.0.tar.gz"
  sha256 "d84f465c1bad900e26346f80038d5ac70cb6af3c4afc8cd5cf18baa790e40134"
  head "https://github.com/marbl/canu.git"
  # doi "10.1038/nbt.3238"
  # tag "bioinformatics"

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
    system "#{bin}/canu"
  end
end
