class MacRequirement < Requirement
  fatal true
  satisfy OS.mac?
  def message
    "This particular packaging is for Mac only."
  end
end

class Scram < Formula
  desc "Probabilistic Risk Analysis Tool"
  homepage "https://scram-pra.org/"
  url "https://downloads.sourceforge.net/project/iscram/scram-0.11.6.tar.gz"
  sha256 "19f43d15f12d6879a3eaf88b0862746fcd7ed2f9df49b6f51de16f155d258dd2"

  bottle do
    sha256 "42623f102a91c5253080664d53f3b54cde1f92a56e524b85a0bb5ef1f8f564b9" => :sierra
    sha256 "21c99f723de2fa25850b1aaf4cc17640170d5cead1b9858ead3bb376fd28610a" => :el_capitan
    sha256 "308d9f66e32bf77b36afbc7e77893a05f2ae5b4e67b46867a3582015055e5947" => :yosemite
  end

  depends_on MacRequirement

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libxml++"
  depends_on "gperftools" => :recommended

  needs :cxx11

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
  end
end
