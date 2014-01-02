require 'formula'

class Armadillo < Formula
  homepage 'http://arma.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/arma/armadillo-3.930.2.tar.gz'
  sha1 'cbd8b2b65d5af4af1e2ab8d93896cd641c27023c'

  depends_on 'cmake' => :build
  depends_on 'boost'

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
