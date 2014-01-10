require 'formula'

class Armadillo < Formula
  homepage 'http://arma.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/arma/armadillo-4.000.0.tar.gz'
  sha1 '93c40772f1d20ca4c0de4e0f758cc2c59f2ab20f'

  depends_on 'cmake' => :build
  depends_on 'boost'

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
