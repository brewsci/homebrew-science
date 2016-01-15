class Spades < Formula
  desc "SPAdes: de novo genome assembly"
  homepage "http://bioinf.spbau.ru/spades/"
  # tag "bioinformatics"
  # doi "10.1089/cmb.2012.0021"
  url "http://spades.bioinf.spbau.ru/release3.6.2/SPAdes-3.6.2.tar.gz"
  sha256 "20897e2707623ee1033d3c88fefc42771fa4bbaafaf0f95642991d83b361eb5f"

  bottle do
    cellar :any
    sha256 "9d69a98a442701f818df56325beeb1ddc8457da5932da172706becf18f6d3fed" => :yosemite
    sha256 "89ff010f4542bb2f63144c642a125fdedee8367a14410bfd3b30c6b27caeb1c9" => :mavericks
    sha256 "834d20f5a8b812cdb8c1e2b9c36a8baf35b5f6e5d7f3af910350713a3357ae5e" => :mountain_lion
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
