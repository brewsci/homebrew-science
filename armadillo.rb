require 'formula'

class Armadillo < Formula
  homepage 'http://arma.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/arma/armadillo-4.500.0.tar.gz'
  sha1 '4747a6fb4350f5adabfb71f3c0031d5ae44b38d3'

  depends_on 'cmake' => :build
  depends_on 'arpack'

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    system "cmake", ".", *std_cmake_args
    system "make install"

    # Copy examples/ directory to prefix
    prefix.install "examples"
  end
end
