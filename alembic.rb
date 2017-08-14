class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://alembic.io"
  url "https://github.com/alembic/alembic/archive/1.7.3.tar.gz"
  sha256 "29f9174d5b092c49aa4cf6bc526b542f0b077ba6a5137cc745d653d732ab8e8f"
  head "https://github.com/alembic/alembic.git"

  bottle do
    sha256 "6a39b72e4ab69817751669e4e58b43958d7e27102940b5071cab7839f38f5e15" => :sierra
    sha256 "85b2de07c14618a60af0a331e83ea4d7e5c0f84f67084539ff801b6d2108825a" => :el_capitan
    sha256 "1d6af097b50ab39834efb89bd19e9cd44c8c91f78af15e6c1a9d9adc8370347b" => :yosemite
    sha256 "230a189fb3eda10ae7b6beb127ef046e568ec9e364313c1d976f676c224273bc" => :x86_64_linux
  end

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "ilmbase"

  def install
    ENV.cxx11
    ENV.prepend "LDFLAGS", "-lmpi" if Tab.for_name("hdf5").with? "mpi"

    cmake_args = std_cmake_args + %w[
      -DUSE_PRMAN=OFF
      -DUSE_ARNOLD=OFF
      -DUSE_MAYA=OFF
      -DUSE_PYALEMBIC=OFF
      -DUSE_HDF5=ON
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
