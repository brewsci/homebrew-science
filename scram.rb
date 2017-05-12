class Scram < Formula
  desc "Probabilistic Risk Analysis Tool"
  homepage "https://scram-pra.org/"
  url "https://github.com/rakhimov/scram/archive/0.13.0.tar.gz"
  sha256 "01c4c3cd98e4a197e2b71b85f3953896e75030f5b70970b65fa5a67dbbdc532a"

  bottle do
    sha256 "42623f102a91c5253080664d53f3b54cde1f92a56e524b85a0bb5ef1f8f564b9" => :sierra
    sha256 "21c99f723de2fa25850b1aaf4cc17640170d5cead1b9858ead3bb376fd28610a" => :el_capitan
    sha256 "308d9f66e32bf77b36afbc7e77893a05f2ae5b4e67b46867a3582015055e5947" => :yosemite
  end

  needs :cxx14

  # C++14 uses GCC 5.3, which is not ABI compatible with GCC 4.8
  depends_on :macos unless OS.mac?

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libxml++"
  depends_on "gperftools" => :recommended

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DBUILD_SHARED_LIBS=OFF" << "-DINSTALL_LIBS=OFF"
      args << "-DBUILD_GUI=OFF" << "-DBUILD_TESTS=OFF"
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/scram", "--help"
    system "#{bin}/scram", "--version"
  end
end
