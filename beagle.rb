require File.expand_path("../Requirements/cuda_requirement", __FILE__)

class Beagle < Formula
  desc "Evaluate the likelihood of sequence evolution on trees"
  homepage "https://github.com/beagle-dev/beagle-lib"
  url "https://github.com/beagle-dev/beagle-lib/archive/beagle_release_2_1_2.tar.gz"
  sha256 "82ff13f4e7d7bffab6352e4551dfa13afabf82bff54ea5761d1fc1e78341d7de"

  head "https://github.com/beagle-dev/beagle-lib.git"
  # doi "10.1093/sysbio/syr100"
  # tag "bioinformatics"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8733c60372d50b85751797333a6ab514ecc317f099a1e0d0f8cc441030b349f2" => :el_capitan
    sha256 "042480e4bf775ca2589450bfa15ae881fd581014edc811d467bc79f73f28f9bf" => :yosemite
    sha256 "f1e1620257b47fee4b487e36cb9e3ae50a3c279f50c7ea25181fd4dd0bee2d6f" => :mavericks
    sha256 "cd26ace4ad12f50c5dc4dd58c44739eef6ace01544f7f03927065526402979fa" => :x86_64_linux
  end

  option "with-test", "Run build-time tests"
  option "with-opencl", "Build with OpenCL GPU/CPU acceleration"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "doxygen" => :build
  depends_on CudaRequirement => :optional

  def install
    system "./autogen.sh"

    args = ["--prefix=#{prefix}"]
    args << "--enable-osx-leopard" if MacOS.version <= :leopard
    args << "--with-cuda=#{Pathname(which("nvcc")).dirname}" if build.with? "cuda"
    args << "--without-cuda" if build.without? "cuda"
    args << "--enable-opencl" if build.with? "opencl"

    system "./configure", *args

    # The JNI bindings cannot be built in parallel, else we get
    # "ld: library not found for -lhmsbeagle"
    # (https://github.com/Homebrew/homebrew-science/issues/67)
    ENV.deparallelize

    system "make"
    system "make", "install"
    system "make", "check" if build.with? "test"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include "libhmsbeagle/platform.h"
      int main()
      {
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}/libhmsbeagle-1",
           testpath/"test.cpp", "-o", "test"
    system "./test"
  end
end
