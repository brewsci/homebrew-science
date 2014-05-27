require 'formula'

class BaliPhy < Formula
  homepage 'http://www.bali-phy.org/'
  url 'http://www.bali-phy.org/bali-phy-2.3.4.tar.gz'
  sha1 'a9a537a3d6a45351a0ff96e480975ef52d7090c7'

  depends_on 'pkg-config' => :build
  depends_on 'cairo'

  needs :cxx11

  def install
    mkdir 'macbuild' do
      system "../configure", "--disable-debug", "--disable-dependency-tracking",
                             "--prefix=#{prefix}",
                             "--enable-cairo",
                             # Necessary for clang 5.0, which has a default depth of 128.
                             # This is fixed in clang 5.1
                             "CXXFLAGS=-ftemplate-depth=256"
      system "make install"
    end
  end
end
