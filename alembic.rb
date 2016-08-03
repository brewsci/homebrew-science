class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://alembic.io"
  url "https://github.com/alembic/alembic/archive/1.6.1.tar.gz"
  sha256 "404195c175323d8c01eef7810d0a66b040645bb3ff6654f7bc176d57454ad00c"
  head "https://github.com/alembic/alembic.git"

  bottle do
    cellar :any
    sha256 "fe01ae8b52ef731a968e4265ba2cb417220c0d24b9c83fba65cd84c417992cf1" => :el_capitan
    sha256 "f15a44339aabbab8d7a720da2f1df254535ad1f06d7be27b4e3c7fe0c015f352" => :yosemite
    sha256 "edf196a94ff53d1d77ffeaecd13323f639ab90ddf102b08fb9e365859b2d5e88" => :mavericks
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
