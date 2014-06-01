require 'formula'

class Cminpack < Formula
  homepage 'http://devernay.free.fr/hacks/cminpack/cminpack.html'
  url 'http://devernay.free.fr/hacks/cminpack/cminpack-1.3.4.tar.gz'
  sha1 '58519c93e9d4e28a17eabb551e4c23b3d39e064d'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
