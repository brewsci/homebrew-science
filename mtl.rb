require 'formula'

class Mtl < Formula
  homepage 'http://www.simunova.com'
  url 'http://www.simunova.com/downloads/mtl4/MTL-4.0.9507-Linux.tar.bz2'
  sha1 '01e72c7d29537d3843d07755fea50c559323aacc'

  head do
    url 'https://simunova.zih.tu-dresden.de/svn/mtl4/trunk', :using => :svn
    depends_on 'cmake' => :build
  end

  depends_on 'boost' => :build

  def install
    if build.head?
      system 'cmake', '-DENABLE_TESTS=OFF', '.', *std_cmake_args
      system 'make', 'install'
    else
      prefix.install 'usr/include', 'usr/share'
    end
  end
end
