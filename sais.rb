require "formula"

class Sais < Formula
  homepage "https://sites.google.com/site/yuta256/"
  url "https://sites.google.com/site/yuta256/sais-2.4.1.zip"
  sha1 "cccf8d8bd18a893c58527d16ce6613923e22b411"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "pkg-config --modversion libsais"
  end
end
