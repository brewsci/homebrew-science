require 'formula'

class Openblas < Formula
  homepage 'http://xianyi.github.com/OpenBLAS/'
  url 'http://github.com/xianyi/OpenBLAS/zipball/v0.1.0'
  md5 '4a33238f68b84bd628701556f12131e0'

  keg_only :provided_by_osx

  def install
    ENV.fortran
    # Must call in two steps
    system "make", "NOLAPACK=1"
    system "make", "NOLAPACK=1", "PREFIX=#{prefix}", "install"
  end
end
