require 'formula'

class Mtl < Formula
  homepage 'http://www.simunova.com'
  url 'http://www.simunova.com/downloads/mtl4/MTL-4.0.9486-Linux.tar.bz2'
  sha1 'dea9d4eb4883588a24d0d6d73b061360904abf9f'
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
