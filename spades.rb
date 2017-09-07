class Spades < Formula
  desc "SPAdes: de novo genome assembly"
  homepage "http://bioinf.spbau.ru/spades/"
  url "http://cab.spbu.ru/files/release3.11.0/SPAdes-3.11.0.tar.gz"
  sha256 "308aa3e6c5fb00221a311a8d32c5e8030990356ae03002351eac10abb66bad1f"
  # doi "10.1089/cmb.2012.0021"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "ad1f80d0722109efe87a053d43ef5ba3a266be3dcd2899edd6abbe75f8c989e4" => :sierra
    sha256 "bffe851df6bad623bf132a3b51c0f3f9e8629d4629cf91bd76f558232860442a" => :el_capitan
    sha256 "3d4f42efafd5935e69e2b9fd1cabba88ce13f1b243e780e809f0459077d8bc8e" => :yosemite
    sha256 "6615043c914a00e88e446cb95ab0143c6c3920934f9ec941af0cb50ac7f01403" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on :python unless OS.mac?

  needs :openmp

  fails_with :gcc => "4.7" do
    cause "Compiling SPAdes requires GCC >= 4.7 for OpenMP 3.1 support"
  end

  def install
    # Fix error: 'uint' does not name a type
    inreplace "src/projects/ionhammer/config_struct.hpp", "uint", "unsigned"

    mkdir "src/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/spades.py", "--test"
  end
end
