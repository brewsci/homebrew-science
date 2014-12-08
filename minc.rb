require 'formula'

# 2.2.20 does not build on OS X. See:
# https://github.com/BIC-MNI/minc/pull/16
# https://github.com/mxcl/homebrew/issues/22152
class Minc < Formula
  homepage 'http://en.wikibooks.org/wiki/MINC'
  url 'https://github.com/BIC-MNI/minc/archive/minc-2-1-13.tar.gz'
  version '2.1.13'
  sha1 '62eeeab62bb5c977e11166d4e43ba384fd029fd1'
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "3db0b7126c24f0d21e10180bd8dd4adee8cda1b8" => :yosemite
    sha1 "0edbcf2269249f2ab56db811e17970df0b468229" => :mavericks
    sha1 "b449228e0c8e7eaf05931a4d1e581af595925aba" => :mountain_lion
  end

  head 'https://github.com/BIC-MNI/minc.git'

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on 'netcdf'
  depends_on 'hdf5'

  fails_with :clang do
    # TODO This is an easy fix, someone send it upstream!
    build 600
    cause "Throws 'non-void function 'miget_real_value_hyperslab' should return a value'"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
