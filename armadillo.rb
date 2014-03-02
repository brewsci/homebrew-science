require 'formula'

class Armadillo < Formula
  homepage 'http://arma.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/arma/armadillo-4.000.4.tar.gz'
  sha1 '0c583fad5fac7714d51e5b6304e3b11ea6e42486'

  depends_on 'cmake' => :build
  depends_on 'arpack'

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
