require 'formula'

class Field3d < Formula
  homepage 'https://sites.google.com/site/field3d/'
  url 'https://github.com/imageworks/Field3D/archive/v1.4.3.tar.gz'
  sha1 '2a6d2bc535cd6c89cbb9dd2fe24734bd83dd9426'
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "a8b12023df85cce80486922f6f1dc799193a73c0" => :yosemite
    sha1 "cda2b036a3a36d3000406943f1f708d0cf71fd0a" => :mavericks
    sha1 "9e7854c38d8af4a2f07f21b931d2751a533813e9" => :mountain_lion
  end

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
