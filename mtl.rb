require 'formula'

class Mtl < Formula
  homepage 'http://www.simunova.com'
  url 'http://www.simunova.com/downloads/mtl4/MTL-4.0.9470-Linux.tar.bz2'
  sha1 '33b27dd5d983f411f4020795ed906b4687ca0df9'

  depends_on 'boost' => :build

  def install
    prefix.install 'usr/include', 'usr/share'
  end
end
