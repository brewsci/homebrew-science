class Cminpack < Formula
  homepage "http://devernay.free.fr/hacks/cminpack/cminpack.html"
  url "http://devernay.free.fr/hacks/cminpack/cminpack-1.3.4.tar.gz"
  sha256 "3b517bf7dca68cc9a882883db96dac0a0d37d72aba6dfb0c9c7e78e67af503ca"
  head "https://github.com/devernay/cminpack.git"

  depends_on "cmake" => :build

  def install
    # https://github.com/devernay/cminpack/pull/4
    # https://github.com/Homebrew/homebrew-science/issues/2696
    inreplace "cmake/CMakeLists.txt", "${CMAKE_ROOT}", "share/cmake"

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
