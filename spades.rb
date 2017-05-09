class Spades < Formula
  desc "SPAdes: de novo genome assembly"
  homepage "http://bioinf.spbau.ru/spades/"
  url "http://cab.spbu.ru/files/release3.10.1/SPAdes-3.10.1.tar.gz"
  sha256 "d49dd9eb947767a14a9896072a1bce107fb8bf39ed64133a9e2f24fb1f240d96"
  revision 1
  # tag "bioinformatics"
  # doi "10.1089/cmb.2012.0021"

  bottle do
    cellar :any
    sha256 "ad1f80d0722109efe87a053d43ef5ba3a266be3dcd2899edd6abbe75f8c989e4" => :sierra
    sha256 "bffe851df6bad623bf132a3b51c0f3f9e8629d4629cf91bd76f558232860442a" => :el_capitan
    sha256 "3d4f42efafd5935e69e2b9fd1cabba88ce13f1b243e780e809f0459077d8bc8e" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on :python if OS.linux?

  needs :openmp

  fails_with :gcc => "4.7" do
    cause "Compiling SPAdes requires GCC >= 4.7 for OpenMP 3.1 support"
  end

  def install
    inreplace "src/common/utils/segfault_handler.hpp",
              /(#include <signal.h>)/, "\\1\n#include <functional>"

    mkdir "src/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/spades.py", "--test"
  end
end
