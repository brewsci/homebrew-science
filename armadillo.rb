require 'formula'

class Armadillo < Formula
  homepage 'http://arma.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/arma/armadillo-4.100.2.tar.gz'
  sha1 '4cf8cb82c8197dda08f019455d006cbc2b093fcf'

  depends_on 'cmake' => :build
  depends_on 'arpack'

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
