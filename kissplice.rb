require "formula"

class KisspliceDownloadStrategy < CurlDownloadStrategy
  def curl(*args)
    args << "--disable-epsv"
    super
  end
end

class Kissplice < Formula
  homepage "http://kissplice.prabi.fr"
  url "ftp://pbil.univ-lyon1.fr/pub/logiciel/kissplice/kissplice-2.2.0.tar.gz",
    :using => KisspliceDownloadStrategy
  sha1 "40625e55bdf20ab5d9ee8d8a68af06460c2eca46"

  depends_on "cmake" => :build

  fails_with :clang do
    build 503
    cause "error: use of undeclared identifiers"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "kissplice --version"
  end
end
