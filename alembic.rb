require "formula"

class Alembic < Formula
  homepage "http://alembic.io"
  url "http://alembic.googlecode.com/archive/1_05_04.zip"
  sha1 "6d3ebdee8c4891bb949203e97baae283148b43e6"
  version "1.5.4"

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
