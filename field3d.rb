require 'formula'

class Field3d < Formula
  homepage 'https://sites.google.com/site/field3d/'
  url 'https://github.com/imageworks/Field3D/archive/v1.4.3.tar.gz'
  sha1 '2a6d2bc535cd6c89cbb9dd2fe24734bd83dd9426'
  revision 1

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'ilmbase'
  depends_on 'hdf5'

  def install
    args = std_cmake_args + %w[-DDOXYGEN_EXECUTABLE=NOTFOUND]
    system "cmake",  *args
    system "make install"
  end
end
