class Spades < Formula
  desc "SPAdes: de novo genome assembly"
  homepage "http://bioinf.spbau.ru/spades/"
  # tag "bioinformatics"
  # doi "10.1089/cmb.2012.0021"
  url "http://spades.bioinf.spbau.ru/release3.7.0/SPAdes-3.7.0.tar.gz"
  sha256 "4d9b114150c4d37084967a5a3264d36a480394996197949fb72402f2d65b42a3"

  bottle do
    cellar :any
    revision 1
    sha256 "fc88b243e7ef3cdc9c73cc2cbb0620da8a7f90856ca57e551cafd5cd75a15d42" => :el_capitan
    sha256 "db922b27bda8afe1b992d47de34f96900ccc29efac8e91c9359ca5776bc7f21e" => :yosemite
    sha256 "12f2f2f6b50d9f142a76fa61a981952601e969dfc7e6ff27cbb1403d3a44682f" => :mavericks
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
