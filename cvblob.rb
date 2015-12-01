class Cvblob < Formula
  homepage "https://code.google.com/p/cvblob/"
  url "https://cvblob.googlecode.com/files/cvblob-0.10.4-src.tgz"
  sha256 "94eff3eed03370fac98e9d26a43405a3ac8eb3ca1621157c5738967b95c67bc1"

  depends_on "cmake" => :build
  depends_on "opencv"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
