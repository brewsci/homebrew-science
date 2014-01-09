require 'formula'

class BaliPhy < Formula
  homepage 'http://www.bali-phy.org/'
  url 'http://www.bali-phy.org/bali-phy-2.2.0.tar.gz'
  sha1 '595dfdd70a2478d2cad518703877d31d61d247eb'

  depends_on 'pkg-config' => :build
  depends_on 'cairo'

  # This package requires C++11, through either gcc-4.8 or through
  # clang 3.3svn in Xcode 5 or newer.
  # Clang 3.4.0 works with libstdc++ from gcc-4.8.
  # On Mavericks, the Xcode defaults (libc++) work.
  fails_with :clang do
     build 425
     cause 'This formula requires C++11 support available in clang build 500 or newer.'
  end

  def install
    mkdir 'macbuild' do
      system "../configure", "--disable-debug", "--disable-dependency-tracking",
                             "--prefix=#{prefix}",
                             "--enable-cairo",
                             # Necessary for clang 5.0, which has a
                             # default depth of 128.
                             "CXXFLAGS=-ftemplate-depth=256"
      system "make install"
    end
  end
end
