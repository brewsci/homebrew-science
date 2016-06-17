class Spades < Formula
  desc "SPAdes: de novo genome assembly"
  homepage "http://bioinf.spbau.ru/spades/"
  url "http://spades.bioinf.spbau.ru/release3.8.1/SPAdes-3.8.1.tar.gz"
  sha256 "8867c5d1fd1ae7eda015a58a0ca518cebe3968ea8a2eb9d85d397243afc6b3b0"
  # tag "bioinformatics"
  # doi "10.1089/cmb.2012.0021"

  bottle do
    cellar :any
    sha256 "6526d2a14aacc3f8baefda09d8632cff099e22b17686fe0ee45928d38111f1fb" => :el_capitan
    sha256 "905914438e52e201c4ce96ac6ba54402bdef6ed3f0842bf648ab707f67ba70ac" => :yosemite
    sha256 "10f98967063facfd4b7af7d2f216171f14abbabe22b279433df25b63289c073a" => :mavericks
    sha256 "10b6daa5500c24f3560ad486a2308c250183b5e71ef55d6a6da9dee0b52d747f" => :x86_64_linux
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
