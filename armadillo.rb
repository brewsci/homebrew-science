require 'formula'

class Armadillo < Formula
  homepage 'http://arma.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/arma/armadillo-3.920.2.tar.gz'
  sha1 'c03a99b203a7f12a95e893ae398fab96d22485aa'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
