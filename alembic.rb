class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://alembic.io"
  url "https://code.google.com/p/alembic/",
    :using => :hg,
    :tag => "1_05_04"
  version "1.5.4"
  revision 1

  bottle do
    cellar :any
    sha256 "fe01ae8b52ef731a968e4265ba2cb417220c0d24b9c83fba65cd84c417992cf1" => :el_capitan
    sha256 "f15a44339aabbab8d7a720da2f1df254535ad1f06d7be27b4e3c7fe0c015f352" => :yosemite
    sha256 "edf196a94ff53d1d77ffeaecd13323f639ab90ddf102b08fb9e365859b2d5e88" => :mavericks
  end

  head "https://code.google.com/p/alembic/", :using => :hg

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python"
  depends_on "hdf5"
  depends_on "ilmbase"

  def install
    ENV.libcxx if ENV.compiler == :clang
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

    lib.install_symlink Dir[prefix/"alembic-#{version}/lib/static/*"]
    include.install_symlink Dir[prefix/"alembic-#{version}/include/*"]
    bin.install_symlink Dir[prefix/"alembic-#{version}/bin/*"]
  end
end
