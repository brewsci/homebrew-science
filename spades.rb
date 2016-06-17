class Spades < Formula
  desc "SPAdes: de novo genome assembly"
  homepage "http://bioinf.spbau.ru/spades/"
  url "http://spades.bioinf.spbau.ru/release3.8.1/SPAdes-3.8.1.tar.gz"
  sha256 "8867c5d1fd1ae7eda015a58a0ca518cebe3968ea8a2eb9d85d397243afc6b3b0"
  # tag "bioinformatics"
  # doi "10.1089/cmb.2012.0021"

  bottle do
    cellar :any
    sha256 "cd62c5f0d7e4b1448cc6add95c57d93ef804b82b29667836553dfb5f7684e978" => :el_capitan
    sha256 "8b57ca106ce3c9e46151efbf10bc1befdf0a666e9ad7d920234502609dbbd005" => :yosemite
    sha256 "7d644a773b9c4ecabecb711f8e10933e978bc542cc155a0a6c9d851d72c57780" => :mavericks
    sha256 "f91c599804c5553fdf41ee37b72207e667f32f8f395cfc9c9b29492210401401" => :x86_64_linux
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

    # Fix audit error "Non-executables were installed to bin"
    inreplace bin/"spades_init.py" do |s|
      s.sub! /^/, "#!/usr/bin/env python\n"
    end
  end

  test do
    system "spades.py", "--test"
  end
end
