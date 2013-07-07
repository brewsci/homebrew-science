require 'formula'

class Mtl < Formula
  homepage 'http://www.mtl4.org/'
  url 'http://www.simunova.com/downloads/mtl4/MTL-4.0.9373-Linux.tar.bz2'
  sha1 '4c4bb8ae61ac6788d419c843b2a50bda6cd093f1'

  def install
    prefix.install 'usr/include', 'usr/share'
  end
end
