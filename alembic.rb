class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://alembic.io"
  url "https://github.com/alembic/alembic/archive/1.7.0.tar.gz"
  sha256 "05d7128f55c3f8846f69e346e824112b0dff8200e83758d2e0b70887f030bffa"
  head "https://github.com/alembic/alembic.git"

  bottle do
    sha256 "cfc316d0102008461f91d65063ba9bae4e6a2f9c9a05d9296dea6fc58c08c652" => :sierra
    sha256 "9978108411c5ccdb7a976b76e4664fd059c6eca7c73302b55f46970fde2db06c" => :el_capitan
    sha256 "c6c191edb0e0d16e80d356a1a2f2020fb9a17714faa7a05f6a98f118197f5194" => :yosemite
  end

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "hdf5" => :build
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
      -DUSE_STATIC_HDF5=ON
      -DUSE_EXAMPLES=ON
    ]
    system "cmake", ".", *cmake_args
    system "make"

    # Re-enable for > 1.7.0
    # system "make", "test"

    system "make", "install"

    pkgshare.install "prman/Tests/testdata/cube.abc"
  end

  test do
    assert_match "root", shell_output("#{bin}/abcls #{pkgshare}/cube.abc")
  end
end
