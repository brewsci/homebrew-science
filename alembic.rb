class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://alembic.io"
  url "https://github.com/alembic/alembic/archive/1.6.1.tar.gz"
  sha256 "404195c175323d8c01eef7810d0a66b040645bb3ff6654f7bc176d57454ad00c"
  head "https://github.com/alembic/alembic.git"

  bottle do
    sha256 "50872f6593ec3c86dd1b254d5350fee29464d214498e3c292a17594ad473e719" => :sierra
    sha256 "0dd08fe3dc38a92833c88ba787dbe862fd76716c0735935cedc10f1276d8a9a2" => :el_capitan
    sha256 "a9fe69855cb72824509ecceb5e38df9e96c5b3a272018766584067c3f64498af" => :yosemite
    sha256 "a6f98148542b541a2de9d9dc9314fec59167af79d1a05d180e7505055d23e7fd" => :mavericks
  end

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "hdf5" => :build
  depends_on "ilmbase"

  def install
    ENV.cxx11
    cmake_args = std_cmake_args + %W[
      -DUSE_PRMAN=OFF
      -DUSE_ARNOLD=OFF
      -DUSE_MAYA=OFF
      -DUSE_PYALEMBIC=OFF
      -DUSE_HDF5=ON
      -DUSE_STATIC_HDF5=ON
      -DUSE_EXAMPLES=ON
    ]
    system "cmake", ".", *cmake_args
    system "make"
    system "make", "test"
    system "make", "install"

    pkgshare.install "prman/Tests/testdata/cube.abc"
  end

  test do
    assert_match "root", shell_output("#{bin}/abcls #{pkgshare}/cube.abc")
  end
end
