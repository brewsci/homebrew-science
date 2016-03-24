class Canu < Formula
  desc "Single molecule sequence assembler"
  homepage "http://canu.readthedocs.org/en/latest/"
  url "https://github.com/marbl/canu/archive/v1.1.tar.gz"
  sha256 "ef06658892c96f4e67b7268e1b257847bff054cec3f3b89d7f56aa895f85a0f6"
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
    system "#{bin}/canu", "--version"
  end
end
