require 'formula'

class Mtl < Formula
  homepage 'http://www.simunova.com'
  url 'http://www.simunova.com/downloads/mtl4/MTL-4.0.9482-Linux.tar.bz2'
  sha1 'cff156ceb8f91a6dac4caba1b17ed6bfab322756'
  head 'https://simunova.zih.tu-dresden.de/svn/mtl4/trunk', :using => :svn

  depends_on 'cmake' => :build if build.head?
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
