require 'formula'

class Openblas < Formula
  homepage 'http://xianyi.github.com/OpenBLAS/'
  url 'http://github.com/xianyi/OpenBLAS/zipball/v0.1.0'
  sha1 '73b6df95993db106b922d8739e273699055c6e79'

  keg_only :provided_by_osx

  def install
    ENV.fortran
    # Must call in two steps
    system "make", "NOLAPACK=1"
    system "make", "NOLAPACK=1", "PREFIX=#{prefix}", "install"
  end
end
