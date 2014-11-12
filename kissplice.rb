require "formula"

class KisspliceDownloadStrategy < CurlDownloadStrategy
  def curl(*args)
    args << "--disable-epsv"
    super
  end
end

class Kissplice < Formula
  homepage "http://kissplice.prabi.fr"
  url "ftp://pbil.univ-lyon1.fr/pub/logiciel/kissplice/download/kissplice-2.2.1.tar.gz",
    :using => KisspliceDownloadStrategy
  sha1 "92b5a3280407de3c363699e10595c1117f1e1e36"

  depends_on "cmake" => :build

  fails_with :clang do
    build 600
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
