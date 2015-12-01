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
  sha256 "229b92d66d96f81f1f7800a7db6317c461e068784e9e48378863479a5634ec47"

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
