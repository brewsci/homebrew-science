require "formula"

class Alembic < Formula
  homepage "http://alembic.io"
  url "https://alembic.googlecode.com/archive/1_05_04.tar.gz"
  sha1 "f50e551b8e18779c4a8a6d818f68da1f28ad624b"
  version "1.5.4"
  head "https://code.google.com/p/alembic/", :using => :hg

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "hdf5"
  depends_on "ilmbase"

  def install
    cmake_args = std_cmake_args + %W[
      -DUSE_PYILMBASE=OFF
      -DUSE_PRMAN=OFF
      -DUSE_ARNOLD=OFF
      -DUSE_MAYA=OFF
      -DUSE_PYALEMBIC=OFF
      -DCMAKE_CXX_FLAGS='-std=c++11'
    ]
    system "cmake", ".", *cmake_args
    system "make", "install"

    #move everything upwards
    lib.install_symlink Dir[prefix/"alembic-#{version}/lib/static/*"]
    include.install_symlink Dir[prefix/"alembic-#{version}/include/*"]
    bin.install_symlink Dir[prefix/"alembic-#{version}/bin/*"]
  end
end
