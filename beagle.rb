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
    sha256 "05f6d54c9d2f3485848ac0dd66352c5966537115c542200ff78085160e8a70a4" => :yosemite
    sha256 "896db76f702251e8a61f34af9d9b8265faf2a607d9090914c0344f5e9cdef17b" => :mavericks
    sha256 "b9d7a9be41827bbf8134c3a6ae484424993b34a20bc0f776fc5c5c5f4600efc2" => :mountain_lion
    sha256 "f97ee10fcf7b053d697bd9b806aaba90fda335d8f99daa62c7342e8ad50854f0" => :x86_64_linux
  end

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
    args << "--enable-opencl" if build.with? "opencl"

    system "./configure", *args

    # The JNI bindings cannot be built in parallel, else we get
    # "ld: library not found for -lhmsbeagle"
    # (https://github.com/Homebrew/homebrew-science/issues/67)
    ENV.deparallelize

    system "make"
    system "make", "install"
    system "make", "check"
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
