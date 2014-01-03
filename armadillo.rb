require 'formula'

class Armadillo < Formula
  homepage 'http://arma.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/arma/armadillo-3.930.3.tar.gz'
  sha1 '5c06ee7fbc8c0add900883ecaf724ba4c8908b13'

  depends_on 'cmake' => :build
  depends_on 'boost'

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
