class Canu < Formula
  desc "Single molecule sequence assembler"
  homepage "http://canu.readthedocs.org/en/latest/"
  url "https://github.com/marbl/canu/archive/v1.0.tar.gz"
  sha256 "d84f465c1bad900e26346f80038d5ac70cb6af3c4afc8cd5cf18baa790e40134"
  head "https://github.com/marbl/canu.git"
  # doi "10.1038/nbt.3238"
  # tag "bioinformatics"

  bottle do
    sha256 "8615ae209f5f64e6048322a60112818635c5b772b4e0e1bb57103bcd94bc027c" => :el_capitan
    sha256 "597617cd2f9575afd87972130e2ddfe33239c683fa7927758eec4ee06eed7d7f" => :yosemite
    sha256 "2cc1b13d28a308f83b85656d1fbeb4ec14108accb256d365500e2ea2f4796eab" => :mavericks
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
    system "#{bin}/canu"
  end
end
