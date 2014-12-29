require "formula"

class Sailfish < Formula
  homepage "http://www.cs.cmu.edu/~ckingsf/software/sailfish"
  #doi "10.1038/nbt.2862"
  #tag "bioinformatics"

  url "https://github.com/kingsfordgroup/sailfish/archive/v0.6.3.tar.gz"
  sha1 "6a8782bf3b1b31e543f5f067dc870c0b45bd8059"

  depends_on "cmake" => :build
  depends_on "boost" => :recommended
  depends_on "tbb" => :recommended

  keg_only "sailfish conflicts with jellyfish."

  fails_with :clang do
    build 600
    cause "Currently, the only supported compiler is GCC(>=4.7). We hope to support Clang soon."
  end

  fails_with :gcc do
    build 5666
    cause "Sailfish requires g++ 4.7 or greater."
  end

  def install
    ENV.deparallelize
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/sailfish", "--version"
  end
end
