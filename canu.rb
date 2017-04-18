class Canu < Formula
  desc "Single molecule sequence assembler"
  homepage "https://canu.readthedocs.org/en/latest/"
  url "https://github.com/marbl/canu/archive/v1.5.tar.gz"
  sha256 "06e2c6d7b9f6d325b3b468e9c1a5de65e4689aed41154f2cee5ccd2cef0d5cf6"
  head "https://github.com/marbl/canu.git"
  # doi "10.1038/nbt.3238"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "7cfb7f33ab82cf1a13871259978ef78f7ef622b8554b59ed2f1a07020a328f5c" => :sierra
    sha256 "0728bf784eea0d77446f88f87c6a74b8e8aa39ac9c22d0429e9c362a9e6ea310" => :el_capitan
    sha256 "56606b88230256f75b78802727f51447b7b0d3b385c2bc032818880ad8f06f69" => :yosemite
    sha256 "817f7fca2ba3a1d56504bbaeee6a040ba93d30b3466e663abd9bb4042705514b" => :x86_64_linux
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
