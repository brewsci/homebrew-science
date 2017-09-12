class Scram < Formula
  desc "Probabilistic Risk Analysis Tool"
  homepage "https://scram-pra.org"
  # Needs to pull submodules to get the customized Tango iconset for Mac.
  url "https://github.com/rakhimov/scram.git",
    :revision => "aa6f9b3737882062af2bc69570bb529ff0f72fd3",
    :tag => "0.15.0"
  revision 1

  head "https://github.com/rakhimov/scram.git"

  bottle do
    sha256 "713d34e4aef68d96c3a00f2ba34ef505a75e2e3de639744e0603928453c03e7c" => :sierra
    sha256 "3dfcfcddeefa5fe548178f6eb6a75b59170efd311476fbaa8349e555e87f1ca1" => :el_capitan
    sha256 "95ead45a8ec47848963f9df023ae9b492cf58ecad5942be546944138b35498e4" => :yosemite
  end

  needs :cxx14

  # C++14 uses GCC 5.3, which is not ABI compatible with GCC 4.8
  depends_on :macos unless OS.mac?

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libxml++"
  depends_on "qt"
  depends_on "gperftools" => :recommended

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DBUILD_SHARED_LIBS=ON" << "-DBUILD_TESTS=OFF"
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/scram", "--help"
    system "#{bin}/scram", "--version"
  end
end
