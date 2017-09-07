class Spades < Formula
  desc "SPAdes: de novo genome assembly"
  homepage "http://bioinf.spbau.ru/spades/"
  url "http://cab.spbu.ru/files/release3.11.0/SPAdes-3.11.0.tar.gz"
  sha256 "308aa3e6c5fb00221a311a8d32c5e8030990356ae03002351eac10abb66bad1f"
  # doi "10.1089/cmb.2012.0021"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "3bdb26858d30ce01e6a643a8c0660f54097347479583c0f196a2a1a309855d93" => :sierra
    sha256 "768f00bcc6d90f2ce23aba7f886a709825e5232bec8a682db8db7b597fc1ef89" => :el_capitan
    sha256 "04f61cf50f6eca0f9364df55cc69c1199f92dcb8d9a0931fe0de8bb731699cab" => :yosemite
    sha256 "4c4fb027ab51e5a8c143e2cec064f45e72489fc6bb62b8c7d53fa82493b08b87" => :x86_64_linux
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
