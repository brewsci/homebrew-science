require "formula"

class Pykep < Formula
  homepage "http://esa.github.io/pykep/"
  url "https://github.com/esa/pykep/archive/1.1.3.tar.gz"
  sha1 "15603482ff38221e874a59c11d4d1a575ee3801f"
  head "https://github.com/esa/pykep.git"
  revision 1

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python"
  depends_on :python

  def install
    mkdir "build" do
      system "cmake", "../", "-DBUILD_TESTS=ON", "-DBUILD_PYKEP=ON", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "python -c 'import PyKEP'"
  end
end
