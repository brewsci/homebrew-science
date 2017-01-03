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
