require 'formula'

class Armadillo < Formula
  homepage 'http://arma.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/arma/armadillo-4.300.3.tar.gz'
  sha1 '0decfda2f7cfa3c3dc534a7e7cc5d88e11794f70'

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
