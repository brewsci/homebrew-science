require 'formula'

class BaliPhy < Formula
  homepage 'http://www.bali-phy.org/'
  url 'http://www.bali-phy.org/bali-phy-2.3.6.tar.gz'
  sha1 '037db27894deb1df5fb7315376e7e1292c50f9c8'

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
