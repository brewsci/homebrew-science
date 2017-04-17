class Canu < Formula
  desc "Single molecule sequence assembler"
  homepage "https://canu.readthedocs.org/en/latest/"
  url "https://github.com/marbl/canu/archive/v1.5.tar.gz"
  sha256 "06e2c6d7b9f6d325b3b468e9c1a5de65e4689aed41154f2cee5ccd2cef0d5cf6"
  head "https://github.com/marbl/canu.git"
  # doi "10.1038/nbt.3238"
  # tag "bioinformatics"

  bottle do
    sha256 "c6eeb78964accfa52f5df247cc07e1ae724a25388897c4cab1cba3039fbe033d" => :sierra
    sha256 "b0aefbb7564f24f07d85557422b709c19ec29c4e491ce0be3415ef08a7a7e290" => :el_capitan
    sha256 "84f57a36a73a45ad302b324d70ce629da0623c97244d296f7a9936b57f349303" => :yosemite
    sha256 "e3e2e9dcf6661e53567bdff4c7cd5404652ad5572a47a0edf7d307badab3eca4" => :x86_64_linux
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
