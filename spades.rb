class Spades < Formula
  desc "SPAdes: de novo genome assembly"
  homepage "http://bioinf.spbau.ru/spades/"
  # tag "bioinformatics"
  # doi "10.1089/cmb.2012.0021"
  url "http://spades.bioinf.spbau.ru/release3.7.0/SPAdes-3.7.0.tar.gz"
  sha256 "4d9b114150c4d37084967a5a3264d36a480394996197949fb72402f2d65b42a3"

  bottle do
    cellar :any
    sha256 "3fd5d0754a3d84c3a99af59424715336d9fcbad4f229d6c8f70319c560a0ee8f" => :el_capitan
    sha256 "fdc450b6256f2e28afc79e6b7d3330d657ae5759626674339b650abe89d691d5" => :yosemite
    sha256 "7826fa02909ef6373bab4d4181ab0af0a9668d94d39e59cf15ae11e5f7ee9931" => :mavericks
  end

  depends_on "cmake" => :build

  needs :openmp

  fails_with :gcc => "4.7" do
    cause "Compiling SPAdes requires GCC >= 4.7 for OpenMP 3.1 support"
  end

  def install
    mkdir "src/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end

    # Fix the audit error "Non-executables were installed to bin"
    inreplace bin/"spades_init.py" do |s|
      s.sub! /^/, "#!/usr/bin/env python\n"
    end
  end

  test do
    system "spades.py", "--test"
  end
end
