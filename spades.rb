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
    sha256 "caeb27819f1264a286a01af17c09749ec20c97653f892a4f81d7a4fcb0a2ad4f" => :sierra
    sha256 "6000968edf4993330a35df019c08fc9521f57c5979ac0053a796f1d910ea9abc" => :el_capitan
    sha256 "5e2b7cfbfb9e5e21362a221eb609a56e59d762f021364d3abd19f57eb8114132" => :yosemite
    sha256 "9a356195baa6bf7e5eda536069a629aea3b76cd6fb49656ae2b29e0070c8a877" => :x86_64_linux
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
