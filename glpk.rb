require 'formula'

class Glpk < Formula
  homepage 'http://www.gnu.org/software/glpk/'
  url 'http://ftpmirror.gnu.org/glpk/glpk-4.52.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/glpk/glpk-4.52.tar.gz'
  sha1 '44b30b0de777a0a07e00615ac6791af180ff4d2c'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make check"
    system "make install"
  end
end
